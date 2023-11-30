class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all
    @ingredients = Ingredient.all

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

  def filter
    filters = filter_params || []

    p filters
    # change to accomodate for filters being a hash instead of an array for cooktime and servings
    # filters.each
    @filtered_ids = Recipe.where(condition: filters).pluck(:id)

    respond_to do |format|
      format.json { render json: @filtered_ids }
    end
  end

  def show
    @recipes = Recipe.all
    @other_recipes = @recipes.sample(3)
  end

  private

  def filter_params
    params.require(:filtersObj).permit(:filtersKey)
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
