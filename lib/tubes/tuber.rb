module Tubes
  class Tuber
    METHODS = [:get, :post, :put, :delete]

    attr_reader :tubes

    def initialize
      @tubes = []
    end

    METHODS.each do |method|
      define_method method do |pattern, controller, action|
        add_tube pattern, method, controller, action
      end
    end

    def add_tube pattern, method, controller, action
      tube = Tubes::Tube.new pattern, method, controller, action
      self.tubes << tube
    end

    def draw &tubes
      self.instance_eval &tubes
    end

    def match request
      self.tubes.find { |tube| tube.matches? request }
    end

    def run request, response
      tube = match request
      tube ? tube.run(request, response) : not_found(response)
    end

    private

    def not_found response
      response.status = 404
      response.write "Page Not Found"
    end
  end
end
