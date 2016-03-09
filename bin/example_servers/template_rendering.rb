# example server 02
# show page renders each cat in the instance variable 'cats'

require 'rack'
require_relative '../../lib/tube_controller'

APP_DIRECTORY = './bin/example_servers'

class CatsController < TubeController
  def go
    @cats = ['Miho', 'Salem']
    render :index
  end
end

server_app = Proc.new do |env|
  request = Rack::Request.new env
  response = Rack::Response.new
  controller = CatsController.new request, response
  controller.go
  response.finish
end

Rack::Server.start app: server_app, Port: 3000
