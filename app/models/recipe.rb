class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :bookmarks, dependent: :destroy
  has_many :posts
  has_many :ingredients, through: :recipe_ingredients
  # has_many_attached :photos
end
