require 'test_helper'

class ManifestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get manifests_create_url
    assert_response :success
  end

end
