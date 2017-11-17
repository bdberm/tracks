require_relative '../orm/sql_object'

class Breed < SQLObject

  has_many :dogs, foreign_key: :breed_id

  finalize!
end
