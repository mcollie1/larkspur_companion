require "test_helper"

class CareNotesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get care_notes_create_url
    assert_response :success
  end

  test "should get update" do
    get care_notes_update_url
    assert_response :success
  end
end
