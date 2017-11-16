require_relative '../orm/sql_object'

class Breed < SQLObject

  has_many :dogs, foreign_key: :owner_id

  finalize!
end
