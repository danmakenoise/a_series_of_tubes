require 'rack'
require 'tubes'
require 'tube_controller'

describe Tubes::Tube do
  let(:request) { Rack::Request.new test_env }
  let(:response) { Rack::MockResponse.new '200', {}, [] }
  let(:test_env) { { 'rack.input' => {} } }
  let(:users_regex) { Regexp.new('^/users/(?<id>\d+)$') }
  before :each do
    allow(request).to receive(:request_method).and_return("GET")
  end

  describe "#matches?" do
    it 'matches simple regular expression' do
      index_tube = Tubes::Tube.new Regexp.new('^/users$'), :get, "_", :_
      allow(request).to receive(:path) { '/users' }
      expect(index_tube.matches?(request)).to be_truthy
    end

    it 'matches regular expression with capture' do
      index_tube = Tubes::Tube.new users_regex, :get, "_", :_
      allow(request).to receive(:path) { '/users/42' }
      expect(index_tube.matches?(request)).to be_truthy
    end

    it 'does not match incorrectly' do
      index_tube = Tubes::Tube.new users_regex, :get, "_", :_
      allow(request).to receive(:path) { '/statuses/1' }
      expect(index_tube.matches?(request)).to be_falsey
    end
  end

  describe '#run' do
    before :all do
      class UselessController
        def initialize _, __, ___
        end
        def invoke_action _
        end
      end

    end

    after(:all) { Object.send :remove_const, "UselessController" }

    it 'instantiates controller' do
      dummy_instance = UselessController.new :_,:_,:_
      dummy_class = UselessController

      allow(UselessController).to receive(:new) { dummy_instance }
      allow(request).to receive(:path) { '/users' }

      index_tube = Tubes::Tube.new Regexp.new('^/users$'), :get, dummy_class, :index
      expect(UselessController).to receive(:new).with request, response, {}
      index_tube.run request, response
    end

    it 'generates proper params' do
      dummy_instance = UselessController.new :_,:_,:_
      dummy_class = UselessController

      allow(UselessController).to receive(:new) { dummy_instance }
      allow(request).to receive(:path) { '/users/42' }

      index_tube = Tubes::Tube.new users_regex, :get, dummy_class, :index
      expect(UselessController).to receive(:new).with request, response, { 'id' => '42' }
      index_tube.run request, response
    end

    it 'calls invoke action on the controller with the specified action' do
      dummy_instance = UselessController.new :_,:_,:_
      dummy_class = UselessController

      allow(UselessController).to receive(:new) { dummy_instance }
      allow(request).to receive(:path) { '/users' }

      expect(dummy_instance).to receive(:invoke_action).with(:index)
      index_tube = Tubes::Tube.new Regexp.new('^/users$'), :get, dummy_class, :index
      index_tube.run request, response
    end
  end
end
