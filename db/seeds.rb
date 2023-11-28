# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "open-uri"
require 'faker'

puts "Deleting all users"
User.destroy_all
puts "Deleting all recipes"
Recipe.destroy_all

5.times do |i|
  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    username: Faker::FunnyName.two_word_name.delete(" "),
    email: "chef#{i}@email.com",
    password: "password"
  )
  user.save!
  puts "User #{i} created"
end

courses = ["starter", "main", "desert"]
5.times do |i|
  recipe = Recipe.new(
    title: Faker::Food.dish,
    cusine: Faker::Food.ethnic_category.split.first,
    course: courses.sample,
    instructions: Faker::Food.description,
    cooktime: rand(1..60)
  )
  recipe.save!
  puts "Recipe #{i} created"
end
