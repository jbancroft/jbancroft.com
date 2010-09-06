require 'spec_helper'

describe 'posts/new.html.haml' do
  it 'renders a form to create a post' do
    assigns[:post] = mock_model(Post, :title => '', :body => '').as_new_record.as_null_object
    render
    response.should have_selector('form', :method => 'post', :action => posts_path) do |form|
      form.should have_selector('input', :type => 'text', :name => 'post[title]', :value => '')
      form.should have_selector('textarea', :name => 'post[body]', :content => '')
      form.should have_selector('input', :type => 'submit', :value => 'Save')
    end
  end
end
