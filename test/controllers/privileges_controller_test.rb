require 'test_helper'

class PrivilegesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get privileges_index_url
    assert_response :success
  end

end
