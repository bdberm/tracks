require 'rack'
require_relative '../../../lib/router'
require_relative './dogs_controller'
require_relative '../../../lib/show_exceptions'

router = Router.new

router.draw do
  get(Regexp.new("^/dogs$"), DogsController, :index)
  get(Regexp.new("^/dogs/new$"), DogsController, :new)
  get(Regexp.new("^/dogs/(?<dog_id>\\d+)$"), DogsController, :show)
  post(Regexp.new("^/dogs$"), DogsController, :create)
  delete(Regexp.new("^/dogs/(?<dog_id>\\d+)$"), DogsController, :destroy)
end


app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req,res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  run app
end.to_app

Rack::Server.start(
  app: app,
  Port: 3000
)
