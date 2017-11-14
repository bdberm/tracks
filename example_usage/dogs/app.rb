require 'rack'
require './dogs_controller'


router = Router.new

router.draw do
  get(Regexp.new("^dogs$"), DogsController, :index)
end


app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req,res)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
