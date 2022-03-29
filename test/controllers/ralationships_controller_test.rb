require "test_helper"

class RalationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get follows" do
    get ralationships_follows_url
    assert_response :success
  end

  test "should get followers" do
    get ralationships_followers_url
    assert_response :success
  end
end
