require_relative '../orm/sql_object'

class Dog < SQLObject
  belongs_to :breed, foreign_key: :breed_id
  belongs_to :owner, foreign_key: :owner_id

  finalize!
end
