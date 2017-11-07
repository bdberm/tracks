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
    method = req.request_method

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

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  #draw routes using the methods dynamically created below for the four
  #http methods
  def draw(&proc)
    self.instance_eval(&proc)
  end

  #make instance method for each of the four http methods
  #method takes arguments for pattern, controller, and action_name
  #creates new route with those three arguments and the http method
  #i.e. get(Regexp.new("^/recipes$", RecipesController, :index)) will
  #create a route for /recipes, with http method get that routes to
  #the RecipesController and the action index within it
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
      res.status = 404
      res.write("No matching route found!")
    end
  end
end
