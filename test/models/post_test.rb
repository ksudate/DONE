require 'test_helper'
require 'time'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = Post.new(line_id: "abcde12345", content: "HelloWorld", deadline: Time.now, rank: "Low")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "line_id should be present" do
    @post.line_id = "     "
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = "     "
    assert_not @post.valid?
  end

  test "deadline should be present" do
    @post.deadline = "     "
    assert_not @post.valid?
  end

  test "rank should be present" do
    @post.rank = "     "
    assert_not @post.valid?
  end

  test "content should not be too long" do
    @post.content = "a" * 141
    assert_not @post.valid?
  end
end
