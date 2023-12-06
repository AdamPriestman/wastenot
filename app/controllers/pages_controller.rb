class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  # might need to remove search

  def home
    @post = Post.all.sample
  end

  def search
    @ingredients = Ingredient.all
  end
end
