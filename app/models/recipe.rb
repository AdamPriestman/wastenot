class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :bookmarks, dependent: :destroy
  has_many :posts
  has_many :ingredients, through: :recipe_ingredients
  validates :title, :description, presence: true

  # def compute_average_rating
  #   posts = self.posts
  #   ratings_array = []
  #   posts.each do |post|
  #     raitings_array << post.ratings
  #   end
  #   ratings_array.all / ratings_array.length
  # end
end
