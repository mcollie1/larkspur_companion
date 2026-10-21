class CoordinatorDashboard
  DOSE_WINDOW = 24.hours

  def initialize(coordinator, now: Time.current)
    @coordinator = coordinator
    @now = now
  end

  def call
    # See call_notes
    patients = @coordinator.assigned_patients
                           .includes(:user, medications: :medication_logs)
                           .to_a

    summaries = patients.map { |patient| summarize(patient) }

    summaries.sort_by do |summary|
      [
        summary[:missed_count].positive? ? 0 : 1,
        -summary[:missed_count],
        -(summary[:last_missed_at]&.to_f || 0)
      ]
    end
  end

  private

    def summarize(patient)
      # See summarize_notes
      recently_missed_meds = MedicationLog
        .where(medication_id: patient.medications.select(:id))
        .where(
          status: MedicationLog::MISSED_STATUS,
          recorded_at: (@now - DOSE_WINDOW)..@now
        )

      # See adherence_history_note

      {
        patient: patient,
        missed_count: recently_missed_meds.size,
        last_missed_at: recently_missed_meds.map(&:recorded_at).max
      }
    end

    def call_notes
      # This service returns the list of patients a coordinator has access
      # to. Currently, it's not pagingated, but it'll be a good idea to paginate
      # this and support filters (assume the medical practice is booming).
      #
      # Given the coordinators need to be alerted if a patient misses their dose
      # within the dose window, the job of this list is to surface those patients
      # first. Therefore, patients are sorted by missed_count and how recently behind
      # they are.
      #
      # A coordinator prioritze these patients and get further details. In the future,
      # the flow will lead to quick actions a coordinator can take in order to
      # get the patient back on track and remediate other issues.
    end

    def summarize_notes
      # For each patient, fetch the patient's medication logs in order to get
      # "missed" statuses. These will inform missed_count and last_missed_at to
      # support quickly surfacing those patients who are recently missing
      # doses
    end

    def adherence_history_note
      # There is a weakness to the 24 hour rule. We can't rely on patients
      # to log medication in order to determine if they're on time or not.
      # We should either use a job or some other means to detect if a patient
      # missed, whether it's logged or not logged. Thus if a patient/caregiver
      # fails to add a log, that's captured also
    end
end
