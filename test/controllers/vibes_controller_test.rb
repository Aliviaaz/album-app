require "test_helper"

class VibesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vibe = vibes(:one)
  end

  test "should get index" do
    get vibes_url
    assert_response :success
  end

  test "should get new" do
    get new_vibe_url
    assert_response :success
  end

  test "should create vibe" do
    assert_difference("Vibe.count") do
      post vibes_url, params: { vibe: { name: @vibe.name } }
    end

    assert_redirected_to vibe_url(Vibe.last)
  end

  test "should show vibe" do
    get vibe_url(@vibe)
    assert_response :success
  end

  test "should get edit" do
    get edit_vibe_url(@vibe)
    assert_response :success
  end

  test "should update vibe" do
    patch vibe_url(@vibe), params: { vibe: { name: @vibe.name } }
    assert_redirected_to vibe_url(@vibe)
  end

  test "should destroy vibe" do
    assert_difference("Vibe.count", -1) do
      delete vibe_url(@vibe)
    end

    assert_redirected_to vibes_url
  end
end
