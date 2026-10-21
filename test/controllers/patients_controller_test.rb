require "test_helper"

class PatientsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get patients_show_url
    assert_response :success
  end
end
