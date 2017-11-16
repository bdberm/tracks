require_relative './dog'
require_relative './breed'
require_relative '../../../lib/controller_base'

class DogsController < ControllerBase
  def index
    @dogs = Dog.all
    render :index
  end

  def create
    @dog  = Dog.new(params["dog"])
    if @dog.valid_save
      flash[:notify] = "New Dog Added!"
      redirect_to "/dogs"
    else
      flash.now[:errors] = @dog.errors
      render :new
    end
  end

  def show
    @dog = Dog.find(params["dog_id"].to_i)
    raise "no such dog" if @dog.nil?
    render :show
  end

  def new
    @breeds = Breed.all
    @owners = Owner.all
    @dog = Dog.new
    render :new
  end

  def destroy
    dog = Dog.find(params["dog_id"].to_i)
    dog.destroy
    redirect_to "/dogs"
  end


end
