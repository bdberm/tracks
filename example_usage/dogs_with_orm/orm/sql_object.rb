# All code taken from ORM built by Ethan Schneider
#GITHUB: https://github.com/ethannkschneider/wORMhole

require_relative 'db_connection'
require_relative './modules/associatable'
require_relative './modules/searchable'
require 'active_support/inflector'
require 'byebug'

class SQLObject

  extend Searchable
  extend Associatable

  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
  end

  def self.finalize!
    self.columns.each do |col|
      define_method("#{col}") { self.attributes[col] }
      define_method("#{col}=") { |col_name| self.attributes[col] = col_name }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
    @table_name
  end

  def self.all
    query = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    self.parse_all(query)
  end

  def self.parse_all(results)
    results.map do |hash|
      self.new(hash)
    end
  end

  def self.find(id)
    new_id = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = #{id}
    SQL
    new_id.empty? ? nil : self.new(new_id.first)
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute \'#{attr_name}\'"
      end
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
    @attributes
  end

  def attribute_values
    self.class.columns.map{ |col| self.send(col) }
  end

  def save
    self.id.nil? ? insert : update
  end


  def destroy
    DBConnection.execute(<<-SQL, self.id)
      DELETE FROM
        #{self.class.table_name}
      WHERE
        id = ?
    SQL
  end

  private

  def insert
    col_names = self.class.columns.join(", ")
    question_marks_unjoined = ["?"] * (self.class.columns.length)
    question_marks = question_marks_unjoined.join(", ")
    attr_vals = self.attribute_values

    DBConnection.execute(<<-SQL, *attr_vals)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_string = self.class.columns.map { |col| "#{col} = ?" }.join(", ")
    attr_vals = self.attribute_values
    DBConnection.execute(<<-SQL, *attr_vals, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_string}
      WHERE
        id = ?
    SQL
  end

end
