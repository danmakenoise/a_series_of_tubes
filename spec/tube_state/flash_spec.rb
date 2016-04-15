require 'rack'
require 'tube_state'
require 'tube_controller'

describe TubeState::Flash do
  let(:request) { Rack::Request.new test_env }
  let(:response) { Rack::MockResponse.new '200', {}, [] }
  let(:test_env) { { 'rack.input' => {} } }
  let(:cookie) { { "_#{APP_NAME}" => { 'indiana' => 'jones' }.to_json } }

  describe '#new' do
    it 'it stores a passed hash' do
      flash = TubeState::Flash.new({'indiana' => 'jones'})
      expect(flash['indiana']).to eq 'jones'
    end
  end

  describe '#now' do
    it 'stores the supplied data into the store' do
      flash = TubeState::Flash.new
      flash.now['marty'] = 'mcfly'
      expect(flash['marty']).to eq 'mcfly'
    end
  end

  it 'outputs only items for the next request cycle' do
    flash = TubeState::Flash.new
    flash['indiana'] = 'jones'
    flash.now['marty'] = 'mcfly'
    expect(flash['indiana']).to be_nil
    expect(flash['marty']).to eq 'mcfly'
  end
end
