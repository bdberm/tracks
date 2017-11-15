# Tracks

## Overview

Tracks is a lightweight MVC framework built in Ruby. It utilizes the [RACK webserver interface](https://github.com/rack/rack) to respond to HTTP requests and with responses that render HTML templates populated by model data to the user.

## Features




### ControllerBase
Controllers all inherit functionality from ControllerBase. This class's main functionality is to respond receive HTTP requests routed from the router and either render content or redirect in response. It's method render(template) will render the given template that follows the convention of being placed within the director: "views/views/#{controller_name}/#{template_name}.html.erb".

redirect_to(url) returns a response with a 302 status code and a 'Location' set to the passed in url. 
