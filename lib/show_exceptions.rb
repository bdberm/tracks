require 'erb'
require 'rack'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue Exception => e
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    filepath="lib/templates/rescue.html.erb"
    file = File.read(filepath)

    error_render = ERB.new(file).result(binding)

    ["500", {"Content-type" => "text/html"}, [error_render]]
  end

end
