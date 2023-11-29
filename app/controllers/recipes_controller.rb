class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
