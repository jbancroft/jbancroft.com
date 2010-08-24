class PostsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :edit, :update]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      flash[:success] = 'Post created successfully'
      redirect_to posts_path
    else
      flash.now[:error] = 'There was a problem creating the post'
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:success] = 'Post updated successfully'
      redirect_to posts_path
    else
      flash.now[:error] = "There was a problem updating the post. Please correct any errors and try again."
      render :edit
    end
  end

  def index
    @posts = Post.all

    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @posts = Post.all
    @post = Post.find(params[:id])
  end
end
