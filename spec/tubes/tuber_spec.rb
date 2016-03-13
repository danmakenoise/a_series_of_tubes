require 'rack'
require 'tubes'
require 'tube_controller'

describe Tubes::Tuber do
  let(:request) { Rack::Request.new test_env }
  let(:response) { Rack::MockResponse.new '200', {}, [] }
  let(:test_env) { { 'rack.input' => {} } }

  let(:users_regex) { Regexp.new('^/users/(?<id>\d+)$') }

  describe '#add_tube' do
    it 'adds a tube' do
      subject.add_tube(1, 2, 3, 4)
      expect(subject.tubes.count).to eq 1

      2.times { subject.add_tube 1, 2, 3, 4 }
      expect(subject.tubes.count).to eq 3
    end
  end

  describe '#match' do
    before :each do
      allow(request).to receive(:request_method) { 'GET' }
    end

    it 'matches a correct tube' do
      subject.add_tube Regexp.new('^/users$'), :get, :_, :_
      allow(request).to receive(:path) { '/users' }
      matched = subject.match request
      expect(matched).not_to be_nil
    end

    it 'does not incorrectly match a tube' do
      subject.add_tube Regexp.new('^/users$'), :get, :_, :_
      allow(request).to receive(:path) { '/srs_bzness' }
      matched = subject.match request
      expect(matched).to be_nil
    end
  end

  describe '#run' do
    before :each do
      allow(request).to receive(:request_method) { 'GET' }
    end

    it 'sets status to 404 if no tube is found' do
      subject.add_tube Regexp.new('^/kanyes$'), :get, :_, :_
      allow(request).to receive(:path) { '/fishsticks' }
      subject.run request, response
      expect(response.status).to eq 404
    end
  end

  describe '#http_methods' do
    it 'dynamically writes each http method' do
      tuber = Tubes::Tuber.new
      Tubes::Tuber::METHODS.each do |method|
        expect(tuber).to respond_to(method)
      end
    end

    it 'adds a tube when each method is called' do
      tuber = Tubes::Tuber.new
      Tubes::Tuber::METHODS.each do |method|
        tuber.send method, Regexp.new('^/kovaches$'), TubeController, :index
      end
      expect(tuber.tubes.count).to eq Tubes::Tuber::METHODS.length
    end
  end

  describe '#draw' do
    it 'calls http methods with the tube information and adds the tube' do
      tuber = Tubes::Tuber.new
      expect(tuber).to receive(:get).and_call_original
      expect(tuber).to receive(:post).and_call_original
      expect(tuber).to receive(:put).and_call_original

      tubes = Proc.new do
        get Regexp.new('^/pea$'), TubeController, :show
        post Regexp.new('^/tear$'), TubeController, :show
        put Regexp.new('^/gryphon$'), TubeController, :show
      end

      tuber.draw &tubes
      expect(tuber.tubes.count).to eq 3
    end
  end
end
