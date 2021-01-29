class PopulateIngredientsAndReceipes < ActiveRecord::Migration[6.0]
  def change
    recipes = recipes_data

    recipes_data.each do |recipe|
      created_recipe = Recipe.create!({
        rate: recipe["rate"]&.to_i,
        author_tip: recipe["author_tip"],
        budget: recipe["budget"],
        prep_time: recipe["prep_time"],
        name: recipe["name"],
        author: recipe["author"],
        difficulty: recipe["difficulty"],
        people_quantity: recipe["people_quantity"]&.to_i,
        cook_time: recipe["cook_time"],
        tags: recipe["tags"],
        total_time: recipe["total_time"],
        nb_comments: recipe["nb_comments"]
      })

      recipe["ingredients"].each do |ingredient|
        Ingredient.create!(name: ingredient, recipe_id: created_recipe.id)
      end
    end
  end

  private

  def recipes_data
    recipes = []
    errors = []

    File.readlines("#{Rails.root}/db/recipes.json").each do |line|
      begin
        recipes.push(JSON.parse(line))
      rescue
        errors.push(line)
      end
    end

    # Take the best and the shortests recipes to do
    recipes = recipes.filter do |recipe|
      !recipe["total_time"].include?("h") &&
      recipe["rate"].to_i > 4 &&
      recipe["people_quantity"].to_i <= 6
    end

    recipes
  end
end
