require_relative './flash.rb'
require 'json'

module TubeState
  class Session
    attr_reader :flash

    def initialize request
      @request = request
      @name = "_#{APP_NAME}"
      @store = read_or_create_session_cookie
      @flash = TubeState::Flash.new self.store['flash']
    end

    def [] key
      self.store[key]
    end

    def []= key, value
      self.store[key] = value
    end

    def store_session response
      self.store['flash'] = @flash.next
      response.set_cookie self.name, generate_cookie_hash
    end

    protected

    attr_reader :name, :request, :store

    private

    def generate_cookie_hash
      output = {}
      output[:value] = self.store.to_json
      output[:path] = '/'
      output
    end

    def read_or_create_session_cookie
      existing_cookie = self.request.cookies[self.name]
      existing_cookie ? JSON.parse(existing_cookie) : {}
    end
  end
end
