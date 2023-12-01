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

  def filter
    filters = filter_params || []
    p filters

    # if filters[:vegan].present? && filters[:vegan] == true
    #   if filters[:servings].to_i <= 8
    #     @filtered_ids = Recipe.where("cooktime <= #{filters[:cooktime]}").and(Recipe.where("vegan = true")).and(Recipe.where("servings <= #{filters[:servings]}")).pluck(:id)
    #   else
    #     @filtered_ids = Recipe.where("cooktime <= #{filters[:cooktime]}").and(Recipe.where("vegan = true")).pluck(:id)
    #   end
    # end

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

    # if filters[:vegatarian].present?

    # end

    # if filters[:glutenFree].present?

    # end

    # if filters[:dairyFree].present?

    # end

    # if filters[:servings].to_i <= 7
    #   @filtered_ids = Recipe.where("cooktime <= #{filters[:cooktime]}").and(Recipe.where("servings <= #{filters[:servings]}")).pluck(:id)
    # else
    #   @filtered_ids = Recipe.where("cooktime <= #{filters[:cooktime]}").pluck(:id)
    # end

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
end
