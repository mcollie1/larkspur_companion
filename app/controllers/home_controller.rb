class HomeController < ApplicationController
  def index
    @coordinators = User.joins(:roles)
      .where(roles: { name: Role::COORDINATOR_ROLE })
      .distinct
      .order(:id)

    @patients_and_caregivers = User.joins(:roles)
      .where(roles: { name: [ Role::PATIENT_ROLE, Role::CAREGIVER_ROLE ] })
      .distinct
      .order(:id)
  end

  private

    def home_notes
      # This was done last minute in order to have something for the UI. This setup
      # allows for quick selections of coordinators and patients/caregivers
      # in order to navigate the UI as one of those personas
    end
end
