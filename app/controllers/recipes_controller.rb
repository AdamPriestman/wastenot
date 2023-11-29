class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all
    @ingredients = Ingredient.all

    if params[:cooktime].present? && params[:servings].present?
      @recipes = Recipe.where("cooktime <= #{params[:cooktime]} AND servings = #{params[:servings]}")
    elsif params[:cooktime].present?
      @recipes = Recipe.where("cooktime <= #{params[:cooktime]}")
    elsif params[:servings].present?
      @recipes = Recipe.where("serving = #{params[:servings]}")
    end

    if params[:ingredient_id].present?
      @ingredient = Ingredient.find(params[:ingredient_id])
      @recipes = @recipes.select { |recipe| recipe.ingredients.include?(@ingredient) }
    end
  end

  def show
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
