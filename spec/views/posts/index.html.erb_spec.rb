require 'spec_helper'

describe 'posts/index.html.erb' do
  before(:each) do
    assigns[:posts] = [
      mock_model(Post, :title => 'First Post Title', :body => 'First Post Body'),
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

end
