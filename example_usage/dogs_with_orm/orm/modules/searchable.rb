# All code taken from ORM built by Ethan Schneider
#GITHUB: https://github.com/ethannkschneider/wORMhole

require_relative '../db_connection'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?"}.join(" AND ")
    vals = params.values
    query = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

    query.map { |data| self.new(data) }
  end
end
