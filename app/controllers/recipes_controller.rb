class RecipesController < ApplicationController
  before_action :ensure_params_present

  def index
    recipes
  end

  private

  def recipes
    @recipes = Recipe.where(people_quantity: params[:people_quantity])

    @recipes = if params[:strict].present?
      @recipes.filter do |recipe|
        recipe.cleaned_ingredient_ids.all? { |id| params[:ingredient_ids].map(&:to_i).include?(id) }
      end
    else
      @recipes.filter do |recipe|
        recipe.cleaned_ingredient_ids.any? { |id| params[:ingredient_ids].map(&:to_i).include?(id) }
      end
    end

    @recipes = @recipes.paginate(page: params[:current_page] || 1, per_page: 10)
  end

  def ensure_params_present
    unless params[:people_quantity].present?
      raise StandardError.new "people_quantity param missing"
    end

    unless params[:ingredient_ids].present?
      raise StandardError.new "ingredient_ids param missing"
    end
  end
end

# RECIPES
# I chose this data model but there is an ther way to do:
# We can do an has_many_and_belongs to table called recipes_ingredients
# In this this table column would be:
# - recipe_id
# - ingredient_id
#
# Thanks to that, we can find recipes matching ingredients:
# - for non strict mode we can do
#
# SELECT * FROM recipes
# INNER JOIN recipes_ingredients ON recipes_ingredients.recipe_id = recipes.id
# WHERE(
#   recipes.peope_quantity = "#{params[:people_quantity]}"
#   AND recipes_ingredients.ingredient_id IN ('params[:ingredient_ids]'))
#) GROUP By recipes.id
#
#- for strict mode:
#
#SELECT * FROM recipes
#INNER JOIN recipes_ingredients ON recipes_ingredients.recipe_id = recipes.id
#WHERE(
# NOT EXIST(
#  SELECT 1 FROM recipes_ingredients
#  WHERE
#   recipes_ingredients.recipes_id = recipes.id AND
#   recipes_ingredients.ingredient_id NOT IN (params[:ingredients_id])
# ) AND ( recipes.people_quantity: params[:people_quantity])
#)
#
#
