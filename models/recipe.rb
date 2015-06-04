require_relative '../db_methods.rb'

class Recipe
  attr_reader :id, :name, :instructions, :description

  def initialize(id, name, instructions, description = 'This recipe doesn\'t have a description')
    @id = id
    @name = name
    @instructions = instructions
    @description = description
  end

  def ingredients
    id = [@id.to_i]
    ingredients_pg = db_connection do |conn|
       conn.exec_params("SELECT ingredients.name FROM ingredients
                 JOIN recipes
                 ON (recipes.id = ingredients.recipe_id)
                 WHERE recipes.id = $1", id)
    end

    ingredients_pg.values.map do |ingredient|
      Ingredient.new(ingredient.first)
    end
  end

  class << self

    def all
      all = db_connection do |conn|
        conn.exec("SELECT * from recipes;")
      end
      all.map do |recipe|
         Recipe.new(recipe["id"], recipe["name"], recipe["instructions"], recipe["description"])
      end
    end

    def find(id)
      all.select { |recipe| recipe.id == id }.first
    end
  end
end
