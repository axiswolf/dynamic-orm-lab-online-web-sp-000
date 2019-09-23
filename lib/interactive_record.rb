require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].results_as_hash = true

   table_columns = DB[:conn].execute("PRAGMA table_info(#{table_name})")
   column_names = []

   table_columns.each do |col|
     column_names << col["name"]
   end

   column_names.compact
  end

  def initialize(attributes)
    attributes.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def attr_accessors
    self.column_names.each do |col_name|
      attr_accessor col_name.to_sym
    end
  end


end
