# Tracks

## Overview

Tracks is a lightweight MVC framework built in Ruby. It utilizes the [RACK webserver interface](https://github.com/rack/rack) to respond to HTTP requests with responses that render HTML templates populated by model data to the user.

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

### Session and Flash
ControllerBase has the ability to set both session and flash cookies in the user's browser. The Flash functionality supports both flash[:cookie] which persists the cookie for one and only one additional request response cycle, and flash now which persists data only for the current cycle without storing any cookies.

### Error Handling
I included a middleware called ShowExceptions that filters incoming requests. If the request returns a 500 Internal Server Error, the middleware will display the error message and the top of the stack trace to the user via the `rescue.html.erb` template

### ORM
The demo utilizes an object relational mapping tool that allows entires in the database to be manipulated as Ruby objects. The ORM tool was developed by [Ethan Schneider](https://github.com/ethannkschneider), and the Github repo can be found [here](https://github.com/ethannkschneider/wORMhole).

Each database table is modeled as a Ruby class that inherits from `SQLObject`. Each instance of `SQLObject` represents a (potential) entry in the database. Using core concepts from meta-programming, the `SQLObject` class dynamically generates getter and setter methods for columns in the database.

### Basic Demo
A rudimentary demo application is included in the `example_usage/dogs` directory. It includes a `dog.rb` class that inherits from `SQLObject`, and `dogs_controller`. The views for the controller are located in the `views/dogs_controller` directory. The demo allows a user to view an index of all dogs, create a new dog, delete a dog and view each dog's show page. To run the demo on localhost/3000 simply, navigate to the root directory, run `bundle install`, then run `ruby example_usage/dogs/lib/app.rb` in the command line. Then navigate to /dogs on your localhost:3000.
