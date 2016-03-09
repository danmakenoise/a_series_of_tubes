require 'json'

module TubeState
  class Session
    def initialize request
      @request = request
      @name = "_#{APP_NAME}"
      @store = read_or_create_session_cookie
    end

    def [] key
      self.store[key]
    end

    def []= key, value
      self.store[key] = value
    end

    def store_session response
      response.set_cookie self.name, generate_cookie_hash.to_json
    end

    protected

    attr_reader :name, :request, :store

    private

    def generate_cookie_hash
      output = {}
      output[:value] = self.store
      output[:path] = '/'
      output
    end

    def read_or_create_session_cookie
      existing_cookie = self.request.cookies[self.name]
      existing_cookie ? JSON.parse(existing_cookie) : {}
    end
  end
end
