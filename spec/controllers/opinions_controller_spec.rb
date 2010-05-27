require 'spec_helper'

describe OpinionsController, 'GET new' do
  get :new do
    should_assign_new :opinion
    should_render 'new'
  end
end

describe OpinionsController, 'POST create' do
  before(:each) do
    @opinion = stub_model(Opinion, :save => nil)
    Opinion.stub(:new).and_return(@opinion)
  end

  it 'creates a new opinion' do
    topic = mock_model(Topic).as_new_record
    author = mock_model(User)
    Opinion.should_receive(:new).with('content' => 'foo',
                                      'topic' => topic,
                                      'author' => author).and_return(@opinion)
    post :create, :opinion => { :content => 'foo', :topic => topic, :author => author }
  end

  it 'saves the opinion' do
    @opinion.should_receive :save
    post :create
  end

  context 'when the opinion saves successfully' do
    before(:each) do
      @opinion.stub(:save).and_return(true)
      @author = Factory(:email_confirmed_user)
      @opinion.stub(:author).and_return(@author)
    end

    post :create do
      should_set_the_flash_with :success => 'Thank you for contributing your opinion'
      should_redirect_to('the user\'s opinions page') { user_opinions_path(@author) }
    end

  end

  context 'when the opinion fails to save' do
    before(:each) do
      @opinion.stub(:save).and_return(false)
    end

    post :create do
      should_set_the_flash_with :error => 'A problem occurred while trying to save your opinion.  Please correct any errors and try again.', :now => true
      should_assign :opinion => @opinion
      should_render 'new'
    end
  end
end

describe OpinionsController, 'GET show' do
  before(:each) do
    @opinion = stub_model(Opinion)
    Opinion.stub(:find).and_return(@opinion)
  end

  get :show do
    should_assign :opinion => @opinion
    should_render 'show'
  end
end
