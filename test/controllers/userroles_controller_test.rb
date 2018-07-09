require 'test_helper'

class UserrolesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get userroles_index_url
    assert_response :success
  end

end
