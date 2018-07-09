require 'test_helper'

class RolemodularsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rolemodulars_index_url
    assert_response :success
  end

end
