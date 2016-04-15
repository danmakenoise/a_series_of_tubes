require 'erb'
require_relative './tube_support'
require_relative './tube_state'

class TubeController
  def initialize request, response, params = {}
    @request = request
    @response = response
    @params = params.merge request.params
  end

  def invoke_action action
    self.send action
    render action unless @rendered
  end

  def redirect_to url
    prevent_double_render
    set_rendered

    self.response.header['location'] = url
    self.response.status = 302
    self.session.store_session self.response
  end

  def render template_name
    controller_name = self.class.to_s.underscore
    filename = "#{APP_DIRECTORY}/views/#{controller_name}/#{template_name}.html.erb"
    render_content ERB.new(File.read(filename)).result(binding), 'text/html'
    self.session.store_session self.response
  end

  def render_content content, content_type
    prevent_double_render
    set_rendered

    self.response['Content-Type'] = content_type
    self.response.write content
    self.session.store_session self.response
  end

  def session
    @session ||= TubeState::Session.new self.request
  end

  def flash
    @flash ||= self.session.flash
  end

  protected

  attr_reader :params, :response, :request

  private

  def prevent_double_render
    raise DoubleRenderError if @rendered
  end

  def set_rendered
    @rendered = true
  end
end

class DoubleRenderError < StandardError
end
