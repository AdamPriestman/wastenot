class Post < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, :description, :rating, :photo, presence: true
  validates :user_id, uniqueness: { scope: :recipe_id, message: "You have already made a post/rating on this recipe!!" }
  has_one_attached :photo
  after_create :update_recipe_rating

  def update_recipe_rating
     self.recipe.compute_average_rating
  end
end
