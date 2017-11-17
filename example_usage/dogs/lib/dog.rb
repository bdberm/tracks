require_relative '../orm/sql_object'
require_relative './breed'
require_relative './owner'

class Dog < SQLObject
  attr_accessor :errors
  belongs_to :breed, foreign_key: :breed_id
  belongs_to :owner, foreign_key: :owner_id

  finalize!

  def valid_save
    if self.name.length > 0 && self.owner_id.to_i != 0  && self.breed_id.to_i != 0
      self.save
      return true
    else
      @errors = ["Need name, owner, and breed to add dog"]
      return false
    end
  end
end
