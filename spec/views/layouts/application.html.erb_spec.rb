require 'spec_helper'

describe 'layouts/application.html.erb' do
  it 'displays the main navigation' do
    render
    response.should have_selector('.nav') do |nav|
      nav.should have_selector('a', :href => new_opinion_path, :content => 'Post an Opinion')
    end
  end
end
