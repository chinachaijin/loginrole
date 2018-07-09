require 'test_helper'

class ModularsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get modulars_index_url
    assert_response :success
  end

end
