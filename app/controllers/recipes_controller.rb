class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all

    if params[:cooktime].present? && params[:servings].present?
      @recipes = Recipe.where("cooktime <= #{params[:cooktime]} AND servings <= #{params[:servings]}")
    elsif params[:cooktime].present?
      @recipes = Recipe.where("cooktime <= #{params[:cooktime]}")
    elsif params[:servings].present?
      @recipes = Recipe.where("serving <= #{params[:servings]}")
    end

    if params[:ingredient1].present?
      @ingredient = Ingredient.find(params[:ingredient1])
      @recipes = @recipes.select { |recipe| recipe.ingredients.include?(@ingredient) }
    end

    if params[:ingredient2].present?
      @ingredient = Ingredient.find(params[:ingredient2])
      @recipes = @recipes.select { |recipe| recipe.ingredients.include?(@ingredient) }
    end

    if params[:ingredient3].present?
      @ingredient = Ingredient.find(params[:ingredient3])
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
