# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

# Uncomment the next line to use webrat's matchers
require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

# Some custom macro modules
module DisableFlashSweeping
  def sweep
  end
end

module AssignMacro
  module ExampleMethods
    def do_action
      verb = [:get, :post, :put, :delete].find{|verb| respond_to? :"do_#{verb}"}
      raise "No do_get, do_post_ do_put, or do_delete has been defined!" unless verb
      send("do_#{verb}")
    end
  end

  module ExampleGroupMethods
    def it_should_assign(variable_name, value=nil)
      it "should assign #{variable_name} to the view" do
        raise "Variable '@#{variable_name}' was not defined in the spec" if value.nil? && !instance_variables.include?("@#{variable_name}")
        value ||= instance_variable_get("@#{variable_name}")
        if value.kind_of?(String) && value.starts_with?("@")
          value = instance_variable_get(value)
        end
        do_action
        assigns[variable_name].should == value
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ExampleGroupMethods
    receiver.send :include, ExampleMethods
  end
end

module ControllerMacros
  def should_render(template)
    it "should render the #{template} template" do
      do_request
      response.should render_template(template)
    end
  end

  def get(action, parameters = nil, session = nil, flash = nil)
    define_method :do_request do
      send(:get, action, parameters.nil? ? parameters : instance_eval(&parameters), session, flash)
    end
    yield
  end
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  config.include(AssignMacro, :type => :controller)
  config.extend(ControllerMacros, :type => :controller)

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses its own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

