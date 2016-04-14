require_relative '../../lib/tubes_app.rb'

APP_NAME = 'cat_app'
APP_DIRECTORY = './bin/example_cat_app'

class Cat
  attr_reader :name, :owner

  def initialize params=nil
    params ||= {}
    @name = params['name']
    @owner = params['owner']
  end
end

class CatsController < TubeController
  def create
    cat = Cat.new params['cat']
    save_cat cat
    redirect_to '/cats'
  end

  def index
    @cats = get_cats_from_cookies
  end

  def new
    @cat = Cat.new
  end

  # private

  def get_cats_from_cookies
    session['cats'] ? session['cats'] : []
  end

  def save_cat cat
    session['cats'] ||= []
    session['cats'] << { owner: cat.owner, name: cat.name }
  end
end

tuber = Tubes::Tuber.new

tuber.draw do
  get  Regexp.new('^/cats$'),     CatsController, :index
  get  Regexp.new('^/cats/new$'), CatsController, :new
  post Regexp.new('^/cats$'),     CatsController, :create
end

server_app = Proc.new do |env|
  request = Rack::Request.new env
  response = Rack::Response.new
  tuber.run request, response
  response.finish
end

Rack::Server.start app: server_app, Port: 3030
