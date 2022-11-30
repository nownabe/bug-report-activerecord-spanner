require 'rails_helper'

RSpec.describe Post, type: :model do
  it do
    post = Post.new(text: "Hi!")
    post.save!
    expect(Post.find(post.id).text).to be_equal("Hi!")
  end
end
