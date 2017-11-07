require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params
  attr_accessor :flash

  def initialize(req, res, route_params={})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
    @already_built_response = false
  end

  # Helper method to check if resonse already returned
  def already_built_response?
    @already_built_response
  end

  # set 302 response and update location
  def redirect_to(url)
    raise "Already delivered response" if self.already_built_response?
    res.status = 302
    res['Location'] = url
    @already_built_response = true
    self.session.store_session(res)
  end

  # Set response content and content type
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already delivered response" if self.already_built_response?
    res['Content-Type'] = content_type
    res.write(content)
    @already_built_response = true
    self.session.store_session(res)

  end

  # use ERB and binding to evaluate templates
  # rely on convention of view paths being "controller_name/template_name.html.erb"
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    filepath = "views/#{controller_name}/#{template_name}.html.erb"
    file  = File.read(filepath)

    to_render  = ERB.new(file).result(binding)

    self.render_content(to_render, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    render unless self.already_built_response?

  end
end
