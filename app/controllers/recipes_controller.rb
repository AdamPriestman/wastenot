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

    # if params[:vegan].to_i == 0
    #   params[:vegan] = false
    # else
    #   params[:vegan] = true
    # end

    # if params[:vegetarian].to_i == 0
    #   params[:vegetarian] = false
    # else
    #   params[:vegetarian] = true
    # end

    # if params[:gluten_free].to_i == 0
    #   params[:gluten_free] = false
    # else
    #   params[:gluten_free] = true
    # end

    # if params[:dairy_free].to_i == 0
    #   params[:dairy_free] = false
    # else
    #   params[:dairy_free] = true
    # end

    # p params[:vegan]

    # if params[:servings].to_i < 8
    #   if params[:ingredient1].present? && params[:ingredient2].present? && params[:ingredient3].present?
    #     @recipes = Recipe.where("ingredient1 = #{params['ingredient1']}").and(Recipe.where("ingredient2 = #{params['ingredient2']}")).and(Recipe.where("ingredient3 = #{params['ingredient3']}")).and(Recipe.where("cooktime <= #{params[:cooktime]}")).and(Recipe.where("servings <= #{params[:servings]}")).and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   elsif params[:ingredient1].present? && params[:ingredient2].present?
    #     @recipes = Recipe.where("ingredient1 = #{params['ingredient1']}").and(Recipe.where("ingredient2 = #{params['ingredient2']}")).and(Recipe.where("cooktime <= #{params[:cooktime]}")).and(Recipe.where("servings <= #{params[:servings]}")).and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   elsif params[:ingredient1].present?
    #     @recipes = Recipe.where("ingredient1 = #{params['ingredient1']}").and(Recipe.where("cooktime <= #{params[:cooktime]}")).and(Recipe.where("servings <= #{params[:servings]}")).and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   else
    #     @recipes = Recipe.where("cooktime <= #{params[:cooktime]}").and(Recipe.where("servings <= #{params[:servings]}")).and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   end
    # else
    #   if params[:ingredient1].present? && params[:ingredient2].present? && params[:ingredient3].present?
    #     @recipes = Recipe.where("ingredient1 = #{params['ingredient1']}").and(Recipe.where("ingredient2 = #{params['ingredient2']}")).and(Recipe.where("ingredient3 = #{params['ingredient3']}")).and(Recipe.where("cooktime <= #{params[:cooktime]}")).and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   elsif params[:ingredient1].present? && params[:ingredient2].present?
    #     @recipes = Recipe.where("ingredient1 = #{params['ingredient1']}").and(Recipe.where("ingredient2 = #{params['ingredient2']}")).and(Recipe.where("cooktime <= #{params[:cooktime]}")).and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   elsif params[:ingredient1].present?
    #     @recipes = Recipe.where("ingredient1 = #{params['ingredient1']}").and(Recipe.where("cooktime <= #{params[:cooktime]}")).and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   else
    #     @recipes = Recipe.where("cooktime <= #{params[:cooktime]}").and(Recipe.where("vegan = #{params[:vegan]}")).and(Recipe.where("vegetarian = #{params[:vegetarian]}")).and(Recipe.where("gluten_free = #{params[:gluten_free]}")).and(Recipe.where("dairy_free = #{params[:dairy_free]}"))
    #   end
    # end

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

    respond_to do |format|
      format.html
      format.text { render partial: "recipes/list", locals: { recipes: @recipes }, formats: [:html] }
    end
  end

  # def filter
  #   # @recipes = Recipe.all
  #   # p params
  #   filters = filter_params || []
  #   # p filters

  #   queries = []
  #   filters.each do |key, value|
  #     if value.class == TrueClass
  #       queries << "#{key} = #{value}" unless (key == "servings" && value == 8)
  #     else
  #       queries << "#{key} <= #{value}"
  #     end
  #   end

  #   case queries.length
  #   when 1
  #     @recipes = Recipe.where(queries[0])
  #   when 2
  #     @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1]))
  #   when 3
  #     @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2]))
  #   when 4
  #     @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2])).and(Recipe.where(queries[3]))
  #   when 5
  #     @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2])).and(Recipe.where(queries[3])).and(Recipe.where(queries[4]))
  #   when 6
  #     @recipes = Recipe.where(queries[0]).and(Recipe.where(queries[1])).and(Recipe.where(queries[2])).and(Recipe.where(queries[3])).and(Recipe.where(queries[4])).and(Recipe.where(queries[5]))
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
