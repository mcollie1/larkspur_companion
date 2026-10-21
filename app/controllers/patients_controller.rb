class PatientsController < ApplicationController
  include CoordinatorAccess

  before_action :set_assigned_patient, only: :show

  def show
    if @patient.nil?
      # See patient_notes
      head :forbidden
    end

    load_medication_logs

    # See adherence_history_note

    # TODO: Add filters for medication, status, and date range.
    # TODO: Paginate history rather than loading every record.
    @care_notes = @patient.care_notes.includes(:author).order(created_at: :desc)
    @care_note = @patient.care_notes.build
  end

  private

    def load_medication_logs
      @medication_logs = MedicationLog
        .joins(:medication)
        .where(medications: { patient_id: @patient.id })
        .includes(:medication, :recorded_by)
        .order(
          Arel.sql("CASE medication_logs.status WHEN 'missed' THEN 0 ELSE 1 END"),
          scheduled_at: :desc
        )
    end

    def medication_log_notes
      # By default, medication logs are scoped to a patient that a coordinator
      # has access to. Our default ordering is such that a coordinator can quickly
      # spot what needs attention
    end

    def patient_notes
      # CoordinatorAccess was a quick way to handle scoping. However, we still
      # should validate the "patient" belongs to the current user by checking
      # the status of patient
      #
      # This presented a query. The current user must be a coodinator. However,
      # should the current user be able to distinguish between an existing patient
      # that he/she does not have access to and a not_found patient? In practice,
      # this would be handled more consistently after we decide the correct
      # behavior. For now, I'm opting to respond to all with a 403.
    end

    def adherence_history_note
      # There is a weakness to the 24 hour rule. We can't rely on patients
      # to log medication in order to determine if they're on time or not.
      # We should either use a job or some other means to detect if a patient
      # missed, whether it's logged or not logged. Thus if a patient/caregiver
      # fails to add a log, that's captured also
    end
end
