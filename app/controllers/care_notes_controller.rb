class CareNotesController < ApplicationController
  include CoordinatorAccess

  before_action :set_assigned_patient
  before_action :set_care_note, only: :update

  def create
    if @patient.nil?
      # See patient_notes
      head :forbidden
    end

    @care_note = @patient.care_notes.build(care_note_params)
    @care_note.author = current_user

    if @care_note.save
      # See rendering_notes
      redirect_to patient_path(@patient, user_id: current_user.id)
    else
      load_medication_logs

      @care_notes = @patient.care_notes.includes(:author).order(created_at: :desc)

      # See rendering_notes
      render "patients/show", status: :unprocessable_entity
    end
  end

  def update
    if @patient.nil?
      # See patient_notes
      head :forbidden
    end

    if @care_note.update(care_note_params)
      # See rendering_notes
      redirect_to patient_path(@patient, user_id: current_user.id)
    else
      # See rendering_notes
      redirect_to patient_path(@patient, user_id: current_user.id)
    end
  end

  private

    def set_care_note
      @care_note = @patient.care_notes.find(params[:id])
    end

    def care_note_params
      params.require(:care_note).permit(:body, :medication_id, :medication_log_id)
    end

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

    def rendering_notes
      # Note: In practie, each action would render JSON. Success and failure
      # states would  handled appropriately by the UI. Given the limited time
      # to act on the assignment, I opted for generic html rendering.
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
end
