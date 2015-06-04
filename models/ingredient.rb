require_relative "../db_methods.rb"

class Ingredient
  attr_reader :name

  def initialize(name)
    @name = name
  end

end
