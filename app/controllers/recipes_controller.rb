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
        params[:ingredient_ids].all? { |id| recipe.cleaned_ingredient_ids.include?(id.to_i) } &&
        params[:ingredients_id].length == recipe.cleaned_ingredient_ids.length
      end
    else
      @recipes.filter do |recipe|
        params[:ingredient_ids].all? { |id| recipe.cleaned_ingredient_ids.include?(id.to_i) }
      end
    end

    @recipes = @recipes.paginate(page: params[:current_page] || 1, per_page: 10)
  end

  def ensure_params_present
    if params[:people_quantity].blank? || params[:ingredient_ids].blank?
      redirect_to root_path
    end
  end
end

# RECIPES
# I chose this data model but there is an ther way to do:
# We can do an has_many_and_belongs_to table called recipes_ingredients
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
# ) GROUP BY recipes.id
#
# - for strict mode:
#
# SELECT * FROM recipes
# INNER JOIN recipes_ingredients ON recipes_ingredients.recipe_id = recipes.id
# WHERE(
#  NOT EXISTS(
#   SELECT 1 FROM recipes_ingredients
#   WHERE
#    recipes_ingredients.recipes_id = recipes.id AND
#    recipes_ingredients.ingredient_id NOT IN (params[:ingredients_id])
#  ) AND ( recipes.people_quantity: params[:people_quantity])
# )
#
#
