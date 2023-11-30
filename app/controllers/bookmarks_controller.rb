class BookmarksController < ApplicationController

  def index
    @bookmarks = Bookmark.all
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    @user = current_user
    @bookmarks = @user.bookmarks
    @recipe = Recipe.find(params[:recipe_id])
    @bookmark = Bookmark.new(recipe: @recipe, user: @user )
    if @bookmark.save
      redirect_to recipe_path(@recipe)
    end
  end
end
