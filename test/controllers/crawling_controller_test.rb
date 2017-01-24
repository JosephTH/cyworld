require 'test_helper'

class CrawlingControllerTest < ActionController::TestCase
  test "should get cyclub" do
    get :cyclub
    assert_response :success
  end

end
