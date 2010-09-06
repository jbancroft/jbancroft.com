require 'spec_helper'

describe 'posts/show.html.haml' do
  before(:each) do
    the_post = stub_model(Post, :created_at => 4.months.ago, :updated_at => 2.days.ago).as_null_object
    assigns[:post] = the_post
    assigns[:posts] = [the_post]
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
