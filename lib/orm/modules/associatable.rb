# All code taken from ORM built by Ethan Schneider
#GITHUB: https://github.com/ethannkschneider/wORMhole

require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions

  def initialize(name, options = {})
    default = {
      foreign_key: "#{name}_id".to_sym,
      class_name: "#{name}".camelcase,
      primary_key: :id,
    }

    options = default.merge(options)
    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    default = {
      foreign_key: "#{self_class_name.downcase}_id".to_sym,
      class_name: "#{name}".singularize.camelcase,
      primary_key: :id
    }

    options = default.merge(options)
    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key_val = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => foreign_key_val).first
    end
  end

  def has_many(name, options = {})
    self_class = "#{self}"
    options = HasManyOptions.new(name, self_class, options)
    assoc_options[name] = options

    define_method(name) do
      primary_key_val = self.send(options.primary_key)
      options.model_class.where(options.foreign_key => primary_key_val)
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]

      source_foreign_key_val = through_options.model_class
      .where(through_options.primary_key => self.send(through_options.foreign_key))
      .first
      .send(source_name)
      .send(source_options.primary_key)

      source_options.model_class.where(source_options.primary_key => source_foreign_key_val).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end
