class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all
    @ingredients = Ingredient.all

    if params[:cooktime].present?
      @recipes = @recipes.select { |recipe| recipe.cooktime <= params[:cooktime].to_i }
    end

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
  end

  def filter
    filters = filter_params || []
    # p filters

    queries = []
    filters.each do |key, value|
      if value.class == TrueClass
        queries << "#{key} = #{value}" unless (key == "servings" && value == 8)
      else
        queries << "#{key} <= #{value}"
      end
    end

    case queries.length
    when 1
      @filtered_ids = Recipe.where("#{queries[0]}")
    when 2
      @filtered_ids = Recipe.where("#{queries[0]}").and(Recipe.where("#{queries[1]}")).pluck(:id)
    when 3
      @filtered_ids = Recipe.where("#{queries[0]}").and(Recipe.where("#{queries[1]}")).and(Recipe.where("#{queries[2]}")).pluck(:id)
    when 4
      @filtered_ids = Recipe.where("#{queries[0]}").and(Recipe.where("#{queries[1]}")).and(Recipe.where("#{queries[2]}")).and(Recipe.where("#{queries[3]}")).pluck(:id)
    when 5
      @filtered_ids = Recipe.where("#{queries[0]}").and(Recipe.where("#{queries[1]}")).and(Recipe.where("#{queries[2]}")).and(Recipe.where("#{queries[3]}")).and(Recipe.where("#{queries[4]}")).pluck(:id)
    when 6
      @filtered_ids = Recipe.where("#{queries[0]}").and(Recipe.where("#{queries[1]}")).and(Recipe.where("#{queries[2]}")).and(Recipe.where("#{queries[3]}")).and(Recipe.where("#{queries[4]}"))..and(Recipe.where("#{queries[5]}")).pluck(:id)
    end

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
