require "test_helper"

class PostTest < ActiveSupport::TestCase
  # If you disable use_transactional_tests, this test works!
  # self.use_transactional_tests = false

  self.use_transactional_tests = true

  test "should be valid" do
    post = Post.new(text: "Hi!")
    post.save!
    assert_equal Post.find(post.id).text, "Hi!"
  end
end
