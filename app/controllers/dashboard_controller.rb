class DashboardController < ApplicationController
  include CoordinatorAccess

  def index
    @patients = ::CoordinatorDashboard.new(current_user).call

    # TODO: Add pagination before this is used with a large caseload.
    # TODO: Add coordinator follow-up actions (e.g. call patient, record outreach).
  end
end
