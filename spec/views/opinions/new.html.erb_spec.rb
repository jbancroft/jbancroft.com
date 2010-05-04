require 'spec_helper'

describe 'opinions/new.html.erb' do
  it 'should have a form for creating a new opinion' do
    assigns[:opinion] = stub_model(Opinion).as_new_record
    render
    response.should have_selector('form') do |form|
      form.should have_selector('label', :content => 'Opinion')
      form.should have_selector('input', :type => 'text', :name => 'opinion[content]')
      form.should have_selector('label', :content => 'Topic')
      form.should have_selector('input', :type => 'text', :name => 'opinion[topic]')
      form.should have_selector('input', :type => 'submit', :value => 'Express Yourself!')
    end
  end
end
