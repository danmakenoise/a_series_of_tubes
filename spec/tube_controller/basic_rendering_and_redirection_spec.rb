require 'rack'
require 'tube_controller'

describe "TubeController | Basic Rendering and Redirection" do
  before :all do
    class UsersController < TubeController
      def index
      end
    end
  end

  after(:all) { Object.send :remove_const, 'UsersController' }

  let(:request) { Rack::Request.new test_env }
  let(:response) { Rack::MockResponse.new '200', {}, [] }
  let(:test_env) { { 'rack.input' => {} } }
  let(:users_controller) { UsersController.new request, response }

  describe '#redirect' do
    before :each do
      users_controller.redirect_to 'http://www.appacademy.io'
    end

    it 'sets the header' do
      expect(response.header['location']).to eq 'http://www.appacademy.io'
    end

    it 'sets the status to 302' do
      expect(response.status).to eq 302
    end
  end

  describe '#render_content' do
    before(:each) { render }

    let(:render) { users_controller.render_content 'somebody', 'text/html' }
    let(:render_again) { users_controller.render_content 'more', 'text/html' }

    it 'sets the response content type' do
      expect(response['Content-Type']).to eq 'text/html'
    end

    it 'sets the response body' do
      expect(response.body).to eq 'somebody'
    end

    it 'prevents double rendering' do
      expect{ render_again }.to raise_error DoubleRenderError
    end
  end
end
