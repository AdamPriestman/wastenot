class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :search]

  def home
  end

  def search
    @ingredients = Ingredient.all
    @ingredient_names = Ingredient.order(:name).map { |ingredient| ingredient.name }
  end
end
