require 'rack'
require 'tube_state'
require 'tube_controller'

APP_NAME = 'my_test_app'

describe TubeState::Session do
  let(:request) { Rack::Request.new test_env }
  let(:response) { Rack::MockResponse.new '200', {}, [] }
  let(:test_env) { { 'rack.input' => {} } }
  let(:cookie) { { "_#{APP_NAME}" => { 'indiana' => 'jones' }.to_json } }

  it 'deserializes json cookie if one exists' do
    request.cookies.merge! cookie
    session = TubeState::Session.new request
    expect(session['indiana']).to eq 'jones'
  end

  describe '#store_session' do
    context 'without cookies in request' do
      before(:each) do
        session = TubeState::Session.new request
        session['marty'] = 'mcfly'
        session.store_session response
      end

      it "adds a cookie named '_#{APP_NAME}' to the response" do
        cookie_string = response.headers['Set-Cookie']
        cookie = Rack::Utils.parse_query cookie_string
        expect(cookie["_#{APP_NAME}"]).not_to be nil
      end

      it "stores the cookie in json format" do
        cookie_string = response.headers['Set-Cookie']
        cookie = Rack::Utils.parse_query cookie_string
        cookie_hash = JSON.parse cookie["_#{APP_NAME}"]
        expect(cookie_hash).to be_a Hash
      end
    end

    context 'with cookies in request' do
      before(:each) do
        cookie = { "_#{APP_NAME}" => { 'doc' => 'brown' }.to_json }
        request.cookies.merge! cookie
      end

      it 'reads the pre-existing data' do
        session = TubeState::Session.new request
        expect(session['doc']).to eq 'brown'
      end

      it 'saves new and old data into the cookie' do
        session = TubeState::Session.new request
        session['time_machine'] = 'delorean'
        session.store_session response

        cookie_string = response.headers['Set-Cookie']
        cookie = Rack::Utils.parse_query cookie_string
        cookie_hash = JSON.parse cookie["_#{APP_NAME}"]
        expect(cookie_hash['doc']).to eq 'brown'
        expect(cookie_hash['time_machine']).to eq 'delorean'
      end
    end
  end
end
