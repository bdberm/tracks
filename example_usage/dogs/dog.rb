class Dog
  attr_reader :name, :owner, :breed

  def self.all
    @dogs ||= [];
  end

  def initialize(name, owner, breed)
    @name = name
    @owner = owner
    @breed = breed
  end

  def valid?
    if self.owner.nil? || self.name.nil? || self.name.nil?
      errors < "Must provide name, owner, and breed"
      return false
    end
  end

  def save
    if self.valid?
      Dog.all << self
      true
    else
      false
    end
  end

  def inspect
    {name: self.name, owner: self.owner, breed: self.breed}
  end

  

end
