class PopulateIngredientsAndReceipes < ActiveRecord::Migration[6.0]
  def change
    recipes = recipes_data
    ingredients = ingredients_data(recipes)

    ingredients_with_ids = {}

    ingredients.each do |ingredient|
      ing = Ingredient.create!(name: ingredient)
      ingredients_with_ids[ing.name] = ing.id
    end

    recipes.each do |recipe|
      recipe_cleaned_ingredient_ids = []
      recipe["cleaned_ingredients"].each do |ingredient|
        recipe_cleaned_ingredient_ids << ingredients_with_ids[ingredient]
      end
      Recipe.create!({
        rate: recipe["rate"]&.to_i,
        author_tip: recipe["author_tip"],
        budget: recipe["budget"],
        prep_time: recipe["prep_time"],
        ingredients: recipe["ingredients"],
        name: recipe["name"],
        author: recipe["author"],
        difficulty: recipe["difficulty"],
        people_quantity: recipe["people_quantity"]&.to_i,
        cook_time: recipe["cook_time"],
        tags: recipe["tags"],
        total_time: recipe["total_time"],
        nb_comments: recipe["nb_comments"],
        cleaned_ingredients: recipe["cleaned_ingredients"],
        cleaned_ingredient_ids: recipe_cleaned_ingredient_ids
      })
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


    recipes.each do |recipe|
      recipe["cleaned_ingredients"] = recipe["ingredients"].map do |ingredient|
        cleaned = ingredient.gsub(/(\d+[g])|(\d)|(\/)|(de )|(^\s)|(cl )|(kg )|(g )|(dl )|(cl )|(ml )|(d')|(environ)/, "").squeeze(' ').strip
        cleaned.gsub(/^de /, "")
      end
    end

    recipes
  end

  def ingredients_data(recipes)
    ingredient_counter = {}

    recipes.each do |recipe|
      recipe["cleaned_ingredients"].each do |ingredient|
        if ingredient_counter[ingredient]
          ingredient_counter[ingredient] += 1
        else
          ingredient_counter[ingredient] = 1
        end
      end
    end

    ingredient_counter.keys
  end
end
