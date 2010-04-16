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
module ControllerMacros
  def should_assign(hash)
    hash.each_pair do |k, v|
      it "should assign @#{k}" do
        raise "Variable '@#{k}' was not defined in the spec" if v.nil? && !instance_variables.include?("@#{k}")
        val ||= instance_variable_get("@#{k}")
        if v.kind_of?(String) && v.starts_with?("@")
          val = instance_variable_get(v)
        end
        do_request
        assigns[k].should == val
      end
    end
  end

  def should_assign_new(variable_name, klass = nil)
    it "should assign @#{variable_name} to a new record" do
      do_request
      assigns[variable_name].should be_a_new_record
      assigns[variable_name].should be_a_kind_of(klass) if klass
    end
  end

  def should_redirect_to(description, &target)
    it "redirects to #{description}" do
      do_request
      response.should redirect_to(instance_eval(&target))
    end
  end

  def should_render(template)
    it "should render the #{template} template" do
      do_request
      response.should render_template(template)
    end
  end

  def should_set_the_flash_with(hash)
    key = hash.keys.first
    expected = hash[key]
    behavior_description = "sets flash#{hash[:now] == true ? '.now' : ''}[#{key}] to #{expected.kind_of?(Regexp) ? 'match ' : ''}#{expected}"
    it behavior_description do
      @controller.instance_eval { flash.stub!(:sweep) } if hash[:now] == true
      if hash[:now] == true
        f = flash.method(:now)
      else
        f = method(:flash)
      end
      do_request
      case expected
      when String
        f.call[key].should == expected
      when Regexp
        f.call[key].should match(expected)
      end
    end
  end

  def get(action, parameters = nil, session = nil, flash = nil)
    define_method :do_request do
      send(:get, action, parameters.nil? ? parameters : instance_eval(&parameters), session, flash)
    end
    yield
  end

  def post(action, parameters = nil, session = nil, flash = nil)
    define_method :do_request do
      send(:post, action, parameters.nil? ? parameters : instance_eval(&parameters), session, flash)
    end
    yield
  end

  def put(action, parameters = nil, session = nil, flash = nil)
    define_method :do_request do
      send(:put, action, parameters.nil? ? parameters : instance_eval(&parameters), session, flash)
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

