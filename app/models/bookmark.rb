class Bookmark < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  validates :recipe_id, uniqueness: { scope: :bookmarks, message: "this recipe is already bookmarked" }
end
