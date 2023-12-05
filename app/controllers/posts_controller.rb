class PostsController < ApplicationController
  before_action :set_recipe, only: %i[new create]
  before_action :set_post, only: %i[edit update destroy]

  def index
    # displays the post in desceding order of time posted
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.recipe = @recipe
    @post.user = current_user
    # db seed has average_rating seeded now. No posts on any of the recipes yet.
    # @recipe.average_rating = @recipe.compute_average_rating
    # redirects to index page of the post
    if @post.save!
      redirect_to posts_path
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  def edit
    @recipe = @post.recipe
  end

  def update
    @post.update(post_params)
    @post.recipe = @recipe
    @post.user = current_user
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
