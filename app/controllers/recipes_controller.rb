class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all
    @ingredients = Ingredient.all
    @ingredients_values = {
      ingredient1: params[:ingredient1].to_i,
      ingredient2: params[:ingredient2].to_i,
      ingredient3: params[:ingredient3].to_i
    }

    if params[:cooktime].present? && params[:cooktime].to_i < 100
      @recipes = @recipes.select { |recipe| recipe.cooktime <= params[:cooktime].to_i }
      # redis = Redis.sadd("filtered_recipes", @recipes)
    end

    # saved_redis = Redis.smembers("filtered_recipes")

    # raise

    if params[:servings].present? && params[:servings].to_i < 8
      @recipes = @recipes.select { |recipe| recipe.servings <= params[:servings].to_i }
    end

    if params[:ingredient1].present?
      @recipes = find_based_on_ingredient(params[:ingredient1])
    end

    if params[:ingredient2].present?
      @recipes = find_based_on_ingredient(params[:ingredient2])
    end

    if params[:ingredient3].present?
      @recipes = find_based_on_ingredient(params[:ingredient3])
    end

    if params[:vegan] == "1"
      @recipes = @recipes.select(&:vegan?)
    end

    if params[:vegetarian] == "1"
      @recipes = @recipes.select(&:vegetarian?)
    end

    if params[:gluten_free] == "1"
      @recipes = @recipes.select(&:gluten_free?)
    end

    if params[:dairy_free] == "1"
      @recipes = @recipes.select(&:dairy_free?)
    end

    respond_to do |format|
      format.html
      format.text { render partial: "recipes/list", locals: { recipes: @recipes }, formats: [:html] }
    end
  end

  # def sort

  # end

  def show
    @recipes = Recipe.all
    @other_recipes = @recipes.sample(3)
  end

  private

  def sort_params
    params.require(:sortCriteria).permit(:sortValue)
  end

  def filter_params
    params.require(:filtersObj).permit(:cooktime, :servings, :vegan, :vegetarian, :gluten_free, :dairy_free)

  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def find_based_on_ingredient(ingredient_id)
    @ingredient = Ingredient.find(ingredient_id)
    @similar_ingredients = Ingredient.where("name ILIKE :ingredient", ingredient: "%#{@ingredient.name}%")
    @recipes.select do |recipe|
      recipe.ingredients.any? do |ingredient|
        @similar_ingredients.include?(ingredient)
      end
    end
  end
end
