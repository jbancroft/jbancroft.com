require 'spec_helper'

describe 'posts/show.html.erb' do
  before(:each) do
    assigns[:post] = stub('Post').as_null_object
  end

  it 'displays the title of the post' do
    assigns[:post].stub(:title).and_return('Test Title')
    render
    response.should contain('Test Title')
  end

  it 'displays the body of the post' do
    assigns[:post].stub(:body).and_return('Test Body')
    render
    response.should contain('Test Body')
  end
end
