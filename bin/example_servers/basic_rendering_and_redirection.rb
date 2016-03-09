# example server 01
# when the path is '/cats' displays 'hello cats!'
# all other paths automatically redirect to '/cats'

require 'rack'
require_relative '../../lib/tube_controller'

class MyController < TubeController
  def go
    if self.request.path == '/cats'
      render_content 'hello cats!', 'text/html'
    else
      redirect_to '/cats'
    end
  end
end

server_app = Proc.new do |env|
  request = Rack::Request.new env
  response = Rack::Response.new
  controller = MyController.new request, response
  controller.go
  response.finish
end

Rack::Server.start app: server_app, Port: 3000
