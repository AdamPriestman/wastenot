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
      if @bookmark.save
        redirect_to bookmarks_path
        # this path need to be changed to re-render the same page
      end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to bookmarks_path(@bookmark), status: :see_other
  end
end
