require "test_helper"

class FreqDictionariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get freq_dictionaries_index_url
    assert_response :success
  end
end
