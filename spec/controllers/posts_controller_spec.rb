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

  it 'renders the index template' do
    get :index
    response.should render_template('index')
  end
end

describe PostsController, 'GET show' do
  before(:each) do
    @post = Factory(:post)
    get :show, :id => @post.id
  end

  it 'retrieves the requested post' do
    assigns[:post].should == @post
  end

  it 'renders the show template' do
    response.should render_template('show')
  end
end
