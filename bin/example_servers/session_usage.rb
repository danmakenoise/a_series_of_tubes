require 'rack'
require_relative '../../lib/tube_controller.rb'

APP_DIRECTORY = './bin/example_servers'
APP_NAME = 'counting'

class CountController < TubeController
  def go
    session["count"] ||= 0
    session["count"] += 1
    render :counting_show
  end
end

server_app = Proc.new do |env|
  request = Rack::Request.new env
  response = Rack::Response.new
  controller = CountController.new request, response
  controller.go
  response.finish
end

Rack::Server.start app: server_app, Port: 3000
