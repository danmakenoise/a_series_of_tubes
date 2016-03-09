require 'erb'

class TubeController
  def initialize request, response
    @request = request
    @response = response
  end

  def redirect_to url
    self.response.header['location'] = url
    self.response.status = 302
  end

  def render_content content, content_type
    prevent_double_render
    set_rendered

    self.response['Content-Type'] = content_type
    self.response.write content
  end

  protected

  attr_reader :response, :request

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
