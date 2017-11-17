require_relative '../orm/sql_object'

class Owner < SQLObject

  has_many :dogs, foreign_key: :owner_id

  finalize!
end
