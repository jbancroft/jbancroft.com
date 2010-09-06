require 'spec_helper'

describe 'layouts/application.html.haml' do
  it 'renders the main navigation' do
    template.should_receive(:render).with(:partial => 'shared/nav')
    render
  end

  it 'renders the flash' do
    template.should_receive(:render).with(:partial => 'shared/flashes')
    render
  end

  context 'when the user is signed out' do
    before(:each) do
      template.stub(:signed_in?).and_return(false)
    end

    it 'displays a sign in link' do
      render
      response.should have_selector('a', :href => sign_in_path, :content => '.sign in')
    end
  end

  context 'when the user is signed in' do
    before(:each) do
      template.stub(:signed_in?).and_return(true)
    end

    it 'displays a sign out link' do
      render
      response.should have_selector('a', :href => sign_out_path, :content => '.sign out')
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
