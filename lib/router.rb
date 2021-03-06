require_relative './controller_base'
require 'byebug'

class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # return true if request path matches route regex pattern and
  # req http method matches route method
  def matches?(req)
    path = req.path
    #use _method param to allow for deletion or edit from form
    method = req.params["_method"] ? req.params["_method"] : req.request_method

    self.pattern =~ path && self.http_method == method.downcase.to_sym

  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    #match pulls out MatchData object with key value pairs matching
    #the regexp expression
    match = @pattern.match(req.path)
    route_params = {}
    match.names.each do |key|
      route_params[key]  = match[key]
    end


    controller = controller_class.new(req, res, route_params)
    controller.invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end


  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  #add routes using the methods dynamically created below within a block
  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
       add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)

    @routes.each do |route|
      return route if route.matches?(req)
    end
    return nil
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    route_to_run = self.match(req)
    if route_to_run
      route_to_run.run(req, res)
    else
      not_found = Route.new("/not_found",'get', ControllerBase, :invalid_route)
      not_found.run(req, res)
    end
  end
end
