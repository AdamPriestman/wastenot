class BookmarksController < ApplicationController

  def index
    @bookmarks = current_user.bookmarks
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @bookmark = Bookmark.new
    @bookmark.user = current_user
    @bookmark.recipe = @recipe
    raise
    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to recipe_path(@recipe) }
        format.text { render partial: "recipes/icon_btn", locals: { recipe: @recipe }, formats: [:html] }
      end
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to bookmarks_path(@bookmark), status: :see_other
  end
end
