require 'spec_helper'

describe PostsController, 'GET new' do
  def do_get
    get :new
  end

  it 'assigns @post to a new post' do
    do_get
    assigns[:post].should be_a_new_record
  end

  it 'renders the new template' do
    do_get
    response.should render_template('new')
  end
end

describe PostsController, 'POST create' do
  before(:each) do
    @post = mock_model(Post, :save => nil)
    Post.stub(:new).and_return(@post)
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

    it 'sets a flash[:success] message' do
      post :create
      flash[:success].should == 'Post created successfully'
    end

    it 'redirects to the posts page' do
      post :create
      response.should redirect_to(posts_path)
    end
  end

  context 'when the post fails to save' do
    before(:each) do
      @post.stub(:save).and_return(false)
    end

    def do_post
      post :create
    end

    it_should_assign :post, @post

    it 'renders the new template' do
      do_post
      response.should render_template('new')
    end

    it 'sets an error message in the flash' do
      @controller.instance_eval { flash.extend(DisableFlashSweeping) }
      do_post
      flash.now[:error].should == 'There was a problem creating the post'
    end
  end
end

describe PostsController, 'GET edit' do
  before(:each) do
    @post = mock_model(Post)
    Post.stub(:find).and_return(@post)
  end

  def do_get
    get :edit, :id => @post.id
  end

  it 'retrieves the post' do
    Post.should_receive(:find).with(@post.id.to_s).and_return(@post)
    do_get
  end

  it_should_assign :post, @post

  it 'renders the edit template' do
    do_get
    response.should render_template('edit')
  end
end

describe PostsController, 'PUT update' do
  before(:each) do
    @post = mock_model(Post).as_null_object
    Post.stub(:find).and_return(@post)
  end

  def do_put
    put :update, :id => @post.id
  end

  it 'retrieves the post' do
    Post.should_receive(:find).with(@post.id.to_s).and_return(@post)
    do_put
  end

  it_should_assign :post, @post

  context 'when the post updates successfully' do
    before(:each) do
      @post.stub(:update_attributes).and_return(true)
    end

    it 'updates the attributes of the specified post' do
      @post.should_receive(:update_attributes).with('title' => 'Modified Test Title', 'body' => 'Modified Test Body').and_return(true)
      put :update, :id => @post.id, :post => { :title => 'Modified Test Title', :body => 'Modified Test Body' }
    end

    it 'sets the flash with a success message' do
      put :update, :id => @post.id
      flash[:success].should == 'Post updated successfully'
    end

    it 'redirects to the posts page' do
      put :update
      response.should redirect_to(posts_path)
    end
  end

  context 'when the post fails to update' do
    before(:each) do
      @post.stub(:update_attributes).and_return(false)
    end

    it 'renders the edit template' do
      put :update, :id => @post.id
      response.should render_template('edit')
    end
  end
end

describe PostsController, 'GET index' do
  it 'assigns @posts to all available posts' do
    @posts = [
      mock_model(Post, :title => 'First Post'),
      mock_model(Post, :title => 'Second Post')
    ]
    Post.should_receive(:all).and_return(@posts)
    get :index
    assigns[:posts].should == @posts
  end

  get :index do
    should_render 'index'
  end
end

describe PostsController, 'GET show' do
  before(:each) do
    @post = Factory(:post)
  end

  def do_get
    get :show, :id => @post.id
  end

  it_should_assign :post, @post

  get :show, lambda { {:id => @post.id} } do
    should_render 'show'
  end
end
