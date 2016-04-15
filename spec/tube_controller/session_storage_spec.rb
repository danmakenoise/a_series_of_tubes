require 'rack'
require 'tube_state'
require 'tube_controller'

APP_NAME = 'my_test_app'

describe TubeController do
  before :all do
    class CatsController < TubeController
    end
  end

  after(:all) { Object.send :remove_const, 'CatsController' }

  let(:request) { Rack::Request.new test_env }
  let(:response) { Rack::MockResponse.new '200', {}, [] }
  let(:test_env) { { 'rack.input' => {} } }
  let(:cats_controller) { CatsController.new request, response }

  describe '#session' do
    it 'returns a session instance' do
      expect(cats_controller.session).to be_a TubeState::Session
    end

    it 'returns the same instance on successive calls' do
      first_result = cats_controller.session
      expect(cats_controller.session).to be first_result
    end
  end

  shared_examples_for "storing session data" do
    it "stores the session data" do
      cats_controller.session['name'] = 'sylvester'
      cats_controller.send(method, *args)
      cookie_string = response['Set-Cookie']
      cookie = Rack::Utils.parse_query cookie_string
      cookie_value = cookie["_#{APP_NAME}"]
      cookie_hash = JSON.parse cookie_value
      expect(cookie_hash['name']).to eq 'sylvester'
    end
  end

  describe '#render_content' do
    let(:method) { :render_content }
    let(:args) { ['test', 'text/plain'] }
    include_examples 'storing session data'
  end

  describe '#redirect_to' do
    let(:method) { :redirect_to }
    let(:args) { ['http://www.appacademy.io'] }
    include_examples 'storing session data'
  end

  describe '#flash' do
    it 'returns a flash instance' do
      expect(cats_controller.flash).to be_a TubeState::Flash
    end

    it 'stores data into the next request cycle' do
      cats_controller.flash['hello'] = 'world'
      cats_controller.send :render_content, 'test', 'text/plain'
      cookie_string = response['Set-Cookie']
      cookie = Rack::Utils.parse_query cookie_string
      cookie_value = cookie["_#{APP_NAME}"]
      cookie_hash = JSON.parse cookie_value
      expect(cookie_hash['flash']['hello']).to eq 'world'
    end

    it 'existing flash data does not persist after one request' do
      request.cookies["_#{APP_NAME}"] = {'flash' => {'hello' => 'world'}}.to_json
      expect(cats_controller.flash['hello']).to eq 'world'
      cats_controller.send :render_content, 'test', 'text/plain'
      cookie_string = response['Set-Cookie']
      cookie = Rack::Utils.parse_query cookie_string
      cookie_value = cookie["_#{APP_NAME}"]
      cookie_hash = JSON.parse cookie_value
      expect(cookie_hash['flash']['hello']).to be_nil
    end
  end
end
