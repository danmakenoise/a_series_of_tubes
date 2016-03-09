require 'byebug'

module Tubes
  class Tube
    attr_reader :pattern, :method, :controller, :action

    def initialize pattern, method, controller, action
      @pattern    = pattern
      @method     = method.to_s.upcase
      @controller = controller
      @action     = action
    end

    def matches? request
      self.pattern =~ request.path && request.request_method == self.method
    end

    def run request, response
      params = parse_params_from_path request.path
      controller = self.controller.new request, response, params
      controller.invoke_action action
    end

    private

    def parse_params_from_path path
      params = {}
      matches = self.pattern.match path

      matches.names.each { |key| params[key] = matches[key] }
      params
    end
  end
end
