class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :bookmarks, dependent: :destroy
  has_many :posts
  has_many :ingredients, through: :recipe_ingredients
  validates :title, :description, presence: true
  has_one_attached :photo

  def compute_average_rating
    posts = self.posts
    ratings_array = []
    posts.each do |post|
      ratings_array << post.rating
    end
    ratings_array.sum / ratings_array.length
  end

end
