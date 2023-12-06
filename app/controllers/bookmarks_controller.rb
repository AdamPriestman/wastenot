class BookmarksController < ApplicationController

  def index
    # @bookmarks = current_user.bookmarks
    @bookmarks = current_user.bookmarks.order(created_at: :desc)
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @bookmark = Bookmark.new
    @bookmark.user = current_user
    @bookmark.recipe = @recipe
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
    @recipe = @bookmark.recipe
    respond_to do |format|
    format.html { redirect_to bookmarks_path(@bookmark), status: :see_other}
    format.text { render partial: "recipes/icon_btn", locals: { recipe: @recipe }, formats: [:html] }
    end
  end
end
