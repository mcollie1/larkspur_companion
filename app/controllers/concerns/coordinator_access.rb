module CoordinatorAccess
  extend ActiveSupport::Concern

  included do
    before_action :require_coordinator!
  end

  private

    def require_coordinator!
      # See permission_notes
      return if current_user&.roles&.exists?(name: Role::COORDINATOR_ROLE)

      head :forbidden
    end

    def set_assigned_patient
      # Scope the lookup to this coordinator's caseload.
      # A patient can only be accessed by a permissioned coordinator. Thus, the
      # patient must belong to the current user via assigned_patients
      @patient = current_user.assigned_patients.find(params[:patient_id] || params[:id])
    end

    def permission_notes
      # Given this assignments requires flows for patients and caregivers, this
      # serves as a quick way to permission those views where the user must
      # be a coordinator. Via includes, we can require_coordinator and set
      # the patient before the other actions execute
    end
end
