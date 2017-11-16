class Dog
  attr_reader :name, :owner, :breed
  attr_accessor :errors

  def self.all
    @dogs ||= {};
  end

  def initialize(params = {})
    params ||= {}
    @name = params["name"]
    @owner = params["owner"]
    @breed = params["breed"]
    @errors = []

  end

  def valid?
    if self.owner == "" || self.owner == "" || self.name == ""
      errors << "Must provide name, owner, and breed"
      return false
    end

    return true
  end

  def save
    if self.valid?
      Dog.all[self.object_id] = self
      true
    else
      false
    end
  end

  def inspect
    {name: self.name, owner: self.owner, breed: self.breed}
  end



end
