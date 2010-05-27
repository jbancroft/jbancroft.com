require 'spec_helper'

describe 'opinions/show.html.erb' do
  before(:each) do
    @author = mock_model(User, :email => 'person1@example.com')
    @opinion = stub_model(Opinion, :author => @author, :content => 'Test content')
    assigns[:opinion] = @opinion
  end

  it 'should show the content of the opinion' do
    render
    response.should have_selector('div', :class => 'opinion_content', :content => @opinion.content)
  end

  it 'should show the author of the opinion' do
    render
    response.should have_selector('div', :class => 'opinion_author', :content => @opinion.author_email)
  end

  it 'should show the timestamps of when the opinion was created and updated' do
    render
    response.should have_selector('div', :class => 'opinion_created_at', :content => @opinion.created_at)
    response.should have_selector('div', :class => 'opinion_updated_at', :content => @opinion.updated_at)
  end
end
