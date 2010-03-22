class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      flash[:success] = 'Post created successfully'
      redirect_to posts_path
    else
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
      render :action => 'edit'
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
