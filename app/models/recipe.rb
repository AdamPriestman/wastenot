class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  validates :title, :description, presence: true
  has_one_attached :photo

  def compute_average_rating
    posts = self.posts
    ratings_array = []
    posts.each do |post|
      ratings_array << post.rating
    end
    average_rating = ratings_array.sum / ratings_array.length.to_f
    self.update(average_rating: average_rating)
  end

  def icons_count
    counter = 0
    counter += 1 if self.vegan?
    counter += 1 if self.vegetarian?
    counter += 1 if self.gluten_free?
    counter += 1 if self.dairy_free?
    counter
  end
end
