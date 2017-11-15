# Tracks

## Overview

Tracks is a lightweight MVC framework built in Ruby. It utilizes the [RACK webserver interface](https://github.com/rack/rack) to respond to HTTP requests and with responses that render HTML templates populated by model data to the user.

## Features

### ControllerBase
Controllers all inherit functionality from ControllerBase. This class's main functionality is to respond receive HTTP requests routed from the router and either render content or redirect in response. It's method render(template) will render the given template that follows the convention of being placed within the director: "views/views/#{controller_name}/#{template_name}.html.erb".

redirect_to(url) returns a response with a 302 status code and a 'Location' set to the passed in url.

### Router
Using the Router class, the user can "draw" routes for the various RESTful methods via the router's draw method. The block provided to the draw method should include function calls with the function being the http_method, and the three arguments being a Regex route patter, the controller class, and the action name corresponding to the method on the controller to be called for the request.
```Ruby
router.draw do
  get(Regexp.new("^/dogs$"), DogsController, :index)
  get(Regexp.new("^/dogs/new$"), DogsController, :new)
  get(Regexp.new("^/dogs/(?<dog_id>\\d+)$"), DogsController, :show)
  post(Regexp.new("^/dogs$"), DogsController, :create)
  delete(Regexp.new("^/dogs/(?<dog_id>\\d+)$"), DogsController, :destroy)
end
```
When the router takes in a request, it matches the method against its existing routes and invokes the controller actions accordingly. If no route is found it invokes the "invlaid_route" method of ControllerBase.

To allow HTML forms to send PATCH or DELETE requests on submit, the route matching checks for params["\_method"]. The creator of the application can add hidden inputs with the name attribute set to "\_method" and the value attribute set to the HTTP method desired
