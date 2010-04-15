require 'spec_helper'

describe Post do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body"
    }
    @post = Post.new(@valid_attributes)
  end

  it "is valid with valid attributes" do
    @post.should be_valid
  end

  it 'is not valid without a title' do
    @post.title = nil
    @post.should_not be_valid
  end

  it 'is not valid without a body' do
    @post.body = nil
    @post.should_not be_valid
  end
end
