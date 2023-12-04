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

    respond_to do |format|
      format.html
      format.text { render partial: "recipes/list", locals: { recipes: @recipes }, formats: [:html] }
    end
  end

  def filter
    # @recipes = Recipe.all
    # p params
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
      @recipes = Recipe.where(queries[0])
    when 2
      @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1]))
    when 3
      @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2]))
    when 4
      @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2])).and(Recipe.where(queries[3]))
    when 5
      @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2])).and(Recipe.where(queries[3])).and(Recipe.where(queries[4]))
    when 6
      @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2])).and(Recipe.where(queries[3])).and(Recipe.where(queries[4])).and(Recipe.where(queries[5]))
    end


  end

  # def sort
  #   @recipes = Recipe.all
  #   p params
  #   sortValue = sort_params

  #   p sortValue
  #   case sortValue[:sortValue]
  #   when 'alphabetical'
  #     @recipes = @recipes.order(title: :asc)
  #     p @recipes.first
  #     p "aplha"
  #   when 'rating'
  #     @recipes = @recipes.order(average_rating: :desc)
  #   else
  #     p "error"
  #   end

  #   respond_to do |format|
  #     format.json { render json: @recipes }
  #   end
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
end
