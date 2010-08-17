require 'spec_helper'

describe 'posts/index.html.erb' do
  before(:each) do
    assigns[:posts] = [
      mock_model(Post, :title => 'First Post Title', :body => 'First Post Body', :created_at => 5.months.ago, :updated_at => 4.months.ago),
      mock_model(Post, :title => 'Second Post Title')
    ]
  end

  it 'displays the title of the first post' do
    render
    response.should contain('First Post Title')
  end

  it 'displays the body of the first post' do
    render
    response.should contain('First Post Body')
  end

  it 'displays when the post was updated' do
    render
    response.should contain('Updated: 4 months ago')
  end

  it 'displays when the post was created' do
    render
    response.should contain('Created: 5 months ago')
  end
end
