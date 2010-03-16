require 'spec_helper'

describe PostsController, 'GET index' do
  it 'retrieves all available posts' do
    @posts = [
      mock_model(Post, :title => 'First Post'),
      mock_model(Post, :title => 'Second Post')
    ]
    Post.should_receive(:all).and_return(@posts)
    get :index
    assigns[:posts].should == @posts
  end
end
