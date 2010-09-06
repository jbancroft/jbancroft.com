require 'spec_helper'

describe PostsController, 'GET new' do
  context 'when the user is signed in' do
    before(:each) do
      user = Factory :email_confirmed_user
      controller.current_user = user
    end

    get :new do
      should_assign_new :post, Post
      should_render 'new'
    end
  end

  get :new do
    should_redirect_to('the sign in page') { sign_in_path }
  end

end

describe PostsController, 'POST create' do
  before(:each) do
    @post = mock_model(Post, :save => nil)
    Post.stub(:new).and_return(@post)
  end

  context 'when the user is signed in' do
    before(:each) do
      user = Factory :email_confirmed_user
      controller.current_user = user
    end

    it 'creates a new post' do
      Post.should_receive(:new).with('title' => 'Test Title', 'body' => 'Test Body').and_return(@post)
      post :create, :post => { :title => 'Test Title', :body => 'Test Body' }
    end

    it 'saves the post' do
      @post.should_receive(:save)
      post :create
    end

    context 'when the post saves successfully' do
      before(:each) do
        @post.stub(:save).and_return(true)
      end

      post :create do
        should_set_the_flash_with :success => 'Post created successfully'
        should_redirect_to('the posts page') { posts_path }
      end
    end

    context 'when the post fails to save' do
      before(:each) do
        @post.stub(:save).and_return(false)
      end

      post :create do
        should_assign :post => @post
        should_render 'new'
        should_set_the_flash_with :error => 'There was a problem creating the post', :now => true
      end
    end
  end
end

describe PostsController, 'GET edit' do
  before(:each) do
    @post = mock_model(Post)
    Post.stub(:find).and_return(@post)
  end

  context 'when the user is signed in' do
    before(:each) do
      user = Factory :email_confirmed_user
      controller.current_user = user
    end

    it 'retrieves the post' do
      Post.should_receive(:find).with(@post.id.to_s).and_return(@post)
      get :edit, :id => @post.id
    end

    get :edit, lambda { {:id => @post.id} } do
      should_assign :post => @post
      should_render 'edit'
    end
  end
end

describe PostsController, 'PUT update' do
  before(:each) do
    @post = mock_model(Post).as_null_object
    Post.stub(:find).and_return(@post)
  end

  context 'when the user is signed in' do
    before(:each) do
      user = Factory :email_confirmed_user
      controller.current_user = user
    end

    it 'retrieves the post' do
      Post.should_receive(:find).with(@post.id.to_s).and_return(@post)
      put :update, :id => @post.id
    end

    put :update, lambda { {:id => @post.id} } do
      should_assign :post => @post
    end

    context 'when the post updates successfully' do
      before(:each) do
        @post.stub(:update_attributes).and_return(true)
      end

      it 'updates the attributes of the specified post' do
        @post.should_receive(:update_attributes).with('title' => 'Modified Test Title', 'body' => 'Modified Test Body').and_return(true)
        put :update, :id => @post.id, :post => { :title => 'Modified Test Title', :body => 'Modified Test Body' }
      end

      put :update, lambda { {:id => @post.id} } do
        should_set_the_flash_with :success => 'Post updated successfully.'
        should_redirect_to('the posts page') { posts_path }
      end
    end

    context 'when the post fails to update' do
      before(:each) do
        @post.stub(:update_attributes).and_return(false)
      end

      put :update, lambda { {:id => @post.id} } do
        should_render 'edit'
        should_set_the_flash_with :error => 'There was a problem updating the post. Please correct any errors and try again.', :now => true
      end
    end
  end
end

describe PostsController, 'GET index' do
  before(:each) do
    @posts = [
      mock_model(Post, :title => 'First Post'),
      mock_model(Post, :title => 'Second Post')
    ]
    Post.should_receive(:all).and_return(@posts)
  end

  get :index do
    should_render 'index'
    should_assign :posts => @posts
  end
end

describe PostsController, 'GET show' do
  before(:each) do
    @post = Factory(:post)
  end

  get :show, lambda { {:id => @post.id} } do
    should_render 'show'
    should_assign :post => @post
  end
end
