require 'test_helper'

class ModularprivilegesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get modularprivileges_index_url
    assert_response :success
  end

end
