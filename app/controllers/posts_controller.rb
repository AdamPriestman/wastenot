class PostsController < ApplicationController
  before_action :set_recipe, only: %i[new create]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.recipe = @recipe
    # redirects to index page of the post
    if @post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def post_params
    params.require(:post).permit(:title, :rating, :description)
  end
end
