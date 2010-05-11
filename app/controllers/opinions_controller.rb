class OpinionsController < ApplicationController
  def new
    @opinion = Opinion.new
  end

  def create
    @opinion = Opinion.new(params[:opinion])
    if @opinion.save
      flash[:success] = 'Thank you for contributing your opinion'
      redirect_to user_opinions_path(@opinion.author)
    else
      flash.now[:error] = 'A problem occurred while trying to save your opinion.  Please correct any errors and try again.'
      render 'new'
    end
  end

  def show
    @opinion = Opinion.find(params[:id])
  end
end
