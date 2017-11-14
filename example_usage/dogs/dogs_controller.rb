require_relative './dogs'
require_relative '../../lib/controller_base'
require_relative '../../lib/show_exceptions'

class DogsController < ControllerBase
  def index
    @dogs = Dog.all
    render :index
  end
end
