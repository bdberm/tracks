require_relative './dog'
require_relative '../../lib/controller_base'

class DogsController < ControllerBase
  def index
    @dogs = Dog.all
    render :index
  end

  def create
    @dog  = Dog.new(params["dog"])
    if @dog.save
      flash[:notify] = "New Dog Added!"
      redirect_to "/dogs"
    else
      flash.now[:errors] = @dog.errors
      render :new
    end
  end

  def show
    @dog = Dog.all[params["dog_id"].to_i]
    raise "no such dog" if @dog.nil?
    render :show
  end

  def new
    @dog = Dog.new
    render :new
  end

  def destroy
    @dog = Dog.all[params["dog_id"].to_i]
    Dog.all.delete(@dog.object_id)
    redirect_to "/dogs"
  end


end
