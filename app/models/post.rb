class Post < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, :description, :rating, presence: true
end
