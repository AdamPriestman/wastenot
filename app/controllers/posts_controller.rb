class PostsController < ApplicationController
  before_action :set_recipe, only: %i[new create]
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.recipe = @recipe
    @post.user = current_user
    # @recipe.average_rating = @post.compute_average_rating
    # redirects to index page of the post
    if @post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe = @post.recipe
  end

  def update
    @post.update(post_params)
    redirect_to posts_path
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def post_params
    params.require(:post).permit(:title, :rating, :description, :photo)
  end
end
