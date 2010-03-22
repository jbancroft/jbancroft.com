require 'spec_helper'

describe 'posts/edit.html.erb' do
  it 'renders a form to edit a pre existing post' do
    assigns[:post] = mock_model(Post, :title => 'Test Title', :body => 'Test Body')
    render
    response.should have_selector('form', :method => 'post', :action => post_path(assigns[:post])) do |form|
      form.should have_selector('input', :type => 'text', :name => 'post[title]', :value => 'Test Title')
      form.should have_selector('textarea', :name => 'post[body]', :content => 'Test Body')
      form.should have_selector('input', :type => 'submit', :value => 'Save')
    end
  end
end
