require 'spec_helper'

class Topic; end

describe Opinion do
  before(:each) do
    @opinion = Opinion.new(:content => 'foo',
                           :topic => mock_model(Topic),
                           :author => Factory(:email_confirmed_user))
  end

  it 'is valid with valid attributes' do
    @opinion.should be_valid
  end

  it 'is not valid without content' do
    @opinion.content = nil
    @opinion.should_not be_valid
  end

  it 'is not valid without a topic' do
    @opinion.topic = nil
    @opinion.should_not be_valid
  end

  it 'is not valid without an author' do
    @opinion.author = nil
    @opinion.should_not be_valid
  end
end
