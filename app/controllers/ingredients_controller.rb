class IngredientsController < ApplicationController
  before_action :ensure_params_present

  def index
    ingredients
  end

  private

  def ingredients
    @ingredients = Ingredient.where("name LIKE :query", query: "%#{params[:query]}%")
    @ingredients = @ingredients.paginate(page: params[:current_page] || 1, per_page: 10)
  end

  def ensure_params_present
    if params[:query].blank?
      redirect_to root_path
    end
  end
end
