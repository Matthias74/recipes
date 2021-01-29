class RecipesController < ApplicationController
  before_action :ensure_params_present

  def index
    recipes
  end

  private

  def recipes
    @recipes = Recipe.select("recipes.*, COUNT(recipes.id) AS occurence")
                    .joins(:ingredients)
                    .where(people_quantity: params[:people_quantity])
                    .where("ingredients.id IN (?)", matching_ingredients_ids)
                    .group(:id)
                    .order("occurence DESC")

    @recipes = @recipes.paginate(page: params[:current_page] || 1, per_page: 10)
  end

  def ensure_params_present
    if params[:people_quantity].blank? || params[:ingredient_names].blank?
      redirect_to root_path
    end
  end

  def ingredient_names
    params[:ingredient_names].join('|')
  end

  def matching_ingredients_ids
    Ingredient.where("name SIMILAR TO ?", "% (#{ingredient_names}) %").pluck(:id)
  end
end
