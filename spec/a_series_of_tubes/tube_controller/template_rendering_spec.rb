require 'rack'
require 'a_series_of_tubes'

APP_NAME = 'cat_app'
APP_DIRECTORY = './spec/a_series_of_tubes/tube_controller'

describe 'ASeriesOfTubes::TubeController | Template Rendering' do
  before :all do
    class CatsController < ASeriesOfTubes::TubeController
      attr_accessor :cats
    end
  end

  after(:all) { Object.send :remove_const, 'CatsController' }

  let(:cats_controller) { CatsController.new request, response }
  let(:request) { Rack::Request.new test_env }
  let(:response) { Rack::MockResponse.new '200', {}, [] }
  let(:test_env) { { 'rack.input' => {} } }

  describe '#render' do
    let(:render) { cats_controller.render :index }
    let(:render_again) { cats_controller.render :index }

    it 'renders the html of the index view' do
      render
      expect(response.body).to include 'ALL THE CATS'
      expect(response.body).to include '<h1>'
      expect(response['Content-Type']).to eq 'text/html'
    end

    it 'binds instance variables and allows rendering in the template' do
      cats_controller.cats = ['miho', 'salem']
      render
      expect(response.body).to include '<p>miho</p>'
      expect(response.body).to include '<p>salem</p>'
    end

    it 'prevents double rendering' do
      render
      expect{ render_again }.to raise_error ASeriesOfTubes::DoubleRenderError
    end
  end
end
