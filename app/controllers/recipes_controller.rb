class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all
    @ingredients = Ingredient.all

    if params[:cooktime].present?
      @recipes = Recipe.where("cooktime <= #{params[:cooktime]}")
    end

    if params[:servings].present? && params[:servings].to_i < 8
      @recipes = Recipe.where("servings <= #{params[:servings]}")
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

    if params[:vegan] == "1"
      @recipes = @recipes.select { |recipe| recipe.vegan? }
    end

    if params[:vegetarian] == "1"
      @recipes = @recipes.select { |recipe| recipe.vegetarian? }
    end

    if params[:gluten_free] == "1"
      @recipes = @recipes.select { |recipe| recipe.gluten_free? }
    end

    if params[:dairy_free] == "1"
      @recipes = @recipes.select { |recipe| recipe.dairy_free? }
    end
  end

  def show
    @recipes = Recipe.all
    @other_recipes = @recipes.sample(3)
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
