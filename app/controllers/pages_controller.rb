class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :search]
  # might need to remove search

  def home
  end

  def search
    @ingredients = Ingredient.all
  end
end
