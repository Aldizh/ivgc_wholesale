require 'test_helper'

class SignupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get signUp" do
    get :signUp
    assert_response :success
  end

end
