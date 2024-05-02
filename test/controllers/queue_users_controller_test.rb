require "test_helper"

class QueueUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @queue_user = queue_users(:one)
  end

  test "should get index" do
    get queue_users_url, as: :json
    assert_response :success
  end

  test "should create queue_user" do
    assert_difference("QueueUser.count") do
      post queue_users_url, params: { queue_user: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show queue_user" do
    get queue_user_url(@queue_user), as: :json
    assert_response :success
  end

  test "should update queue_user" do
    patch queue_user_url(@queue_user), params: { queue_user: {  } }, as: :json
    assert_response :success
  end

  test "should destroy queue_user" do
    assert_difference("QueueUser.count", -1) do
      delete queue_user_url(@queue_user), as: :json
    end

    assert_response :no_content
  end
end
