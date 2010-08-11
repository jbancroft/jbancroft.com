require 'spec_helper'

describe 'layouts/application.html.erb' do
  it 'displays the main navigation' do
    render
    response.should have_selector('ul', :id => 'nav') do |nav|
      nav.should have_selector('a', :href => new_opinion_path, :content => 'Post an Opinion')
    end
  end
  
  it 'displays the header' do
    render
    response.should have_selector('div', :id => 'header')
  end

  it 'displays the content' do
    render
    response.should have_selector('div', :id => 'content')
  end
end
