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
require 'net/http'

puts "Deleting all users"
User.destroy_all
puts "Deleting all recipes"
RecipeIngredient.destroy_all
Ingredient.destroy_all
Recipe.destroy_all

5.times do |i|
  photo = URI.open("https://i.pinimg.com/236x/6d/a4/de/6da4de74f8540aaa6c83804434e64687.jpg")
  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    username: Faker::FunnyName.two_word_name.delete(" "),
    email: "chef#{i + 1}@email.com",
    password: "password"
  )
  user.photo.attach(io: photo, filename: "profile.png", content_type: "image/png")
  user.save!
  puts "User #{i + 1} created"
end

def get_recipes(url)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = ENV["X_RapidAPI_Key"]
  request["X-RapidAPI-Host"] = ENV["X_RapidAPI_Host"]

  response = http.request(request)
  recipes_json = JSON.parse(response.read_body)
  recipes = recipes_json["results"]

  recipe_counter = 1
  recipes.each do |recipe|
    instructions_array = []
    instructions = recipe["analyzedInstructions"]
    instructions.each do |recipe_instructions|
      steps = recipe_instructions["steps"]
      steps.each do |step|
        instructions_array.push("#{step['number']}.#{step['step'].gsub(/<\/?.>/, '')}")
      end
    end
    local_recipe = Recipe.create(
      title: recipe["title"],
      preptime: recipe["preparationMinutes"],
      cooktime: recipe["cookingMinutes"],
      cuisine: recipe["cuisines"].join(", "),
      course: recipe["dishTypes"].join(", "),
      description: recipe["summary"].gsub(/<\/?.>/, ""),
      instructions: instructions_array.join,
      servings: recipe["servings"],
      source: recipe["creditsText"],
      image: recipe["image"],
      vegan: recipe["vegan"],
      vegetarian: recipe["vegetarian"],
      gluten_free: recipe["glutenFree"],
      dairy_free: recipe["dairyFree"],
      average_rating: rand(3.2..5.0).floor(1)
    )

    photo = URI.open(recipe["image"])
    local_recipe.photo.attach(io: photo, filename: "food.png", content_type: "image/png")
    local_recipe.save!

    puts "Recipe #{recipe_counter} created"

    # instructions.each do |instruction|
    #   steps = instruction["steps"]
    #   steps.each do |step|
    #     ingredients = step["ingredients"]
    #     ingredients.each do |ingredient|
    #       existing_ingredients = Ingredient.where("name=?", ingredient["name"])
    #       if existing_ingredients.empty?
    #         local_ingredient = Ingredient.create(name: ingredient["name"])
    #       else
    #         local_ingredient = existing_ingredients.first
    #       end
    #       recipe_ingredient = RecipeIngredient.new
    #       recipe_ingredient.ingredient = local_ingredient
    #       recipe_ingredient.recipe = local_recipe
    #       recipe_ingredient.save!
    #     end
    #   end
    #   puts "Ingredients added to recipe #{recipe_counter}"
    # end

    ingredients = recipe["extendedIngredients"]
    ingredients.each do |ingredient|
      existing_ingredients = Ingredient.where("name=?", ingredient["nameClean"])
      if existing_ingredients.empty?
        local_ingredient = Ingredient.create(name: ingredient["nameClean"])
      else
        local_ingredient = existing_ingredients.first
      end
      recipe_ingredient = RecipeIngredient.new(
        quantity: ingredient["measures"]["metric"]["amount"].floor(1),
        units: ingredient["measures"]["metric"]["unitShort"]
      )
      recipe_ingredient.ingredient = local_ingredient
      recipe_ingredient.recipe = local_recipe
      recipe_ingredient.save!
    end
    puts "Ingredients added to recipe #{recipe_counter}"

    recipe_counter += 1
  end

  puts "Deleting negative cooktime recipes"
  bad_seeds = Recipe.where("cooktime<0")
  bad_seeds.each(&:destroy)

  puts "Deleting empty ingredients"
  bad_seeds = Ingredient.select { |ingredient| ingredient.name.nil? }
  bad_seeds.each(&:destroy)
end

url = URI("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=pasta&cuisine=italian&instructionsRequired=true&fillIngredients=true&addRecipeInformation=true&ignorePantry=true&number=30&limitLicense=false")

# 30 pasta results no ingredients passed
puts "Pasta time"
puts "_____________"
puts "_____________"
get_recipes(url)

puts "Creating posts about pasta recipes"

photo = URI.open("https://assets.epicurious.com/photos/55f72d733c346243461d496e/master/pass/09112015_15minute_pastasauce_tomato.jpg")
post = Post.new(
  title: "Delicious Pasta Recipe",
  rating: 5,
  description: "Deliciously simple pasta recipe! The blend of fresh tomatoes, basil, and garlic created a burst of flavor. Easy-to-follow steps made cooking a breeze. A definite go-to for a satisfying meal!"
)

post.user = User.all.sample
post.recipe = Recipe.all.sample
post.photo.attach(io: photo, filename: "food.png", content_type: "image/png")
post.save!

photo = URI.open("https://graphics8.nytimes.com/images/2015/07/27/dining/27SPAGHETTI/27SPAGHETTI-superJumbo.jpg")
post = Post.new(
  title: "Great Taste, Minor Tweaks: Pasta Success!",
  rating: 4,
  description: "Pasta nails flavor! A tweak or two could enhance. Great taste, simple steps; a recipe ripe for personal touches and culinary exploration!"
)

post.user = User.all.sample
post.recipe = Recipe.all.sample
post.photo.attach(io: photo, filename: "food.png", content_type: "image/png")
post.save!

photo = URI.open("https://www.budgetsavvydiva.com/wp-content/uploads/2015/01/garlic-pasta-2.jpg")
post = Post.new(
  title: "Simplicity Refined: Perfectly Balanced Pasta Harmony!",
  rating: 5,
  description: "A flawless balance! This pasta dish achieves culinary harmony—simple yet deeply satisfying. Every element sings in perfect unison, a true delight!"
)

post.user = User.all.sample
post.recipe = Recipe.all.sample
post.photo.attach(io: photo, filename: "food.png", content_type: "image/png")
post.save!

url = URI("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=rice&instructionsRequired=true&fillIngredients=true&addRecipeInformation=true&ignorePantry=true&number=40&limitLicense=false")

# 40 rice recipes
puts "Rice rice baby"
puts "_____________"
puts "_____________"
get_recipes(url)

url = URI("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=chicken&instructionsRequired=true&fillIngredients=true&addRecipeInformation=true&ignorePantry=true&number=40&limitLicense=false")

# 40 chicken recipes
puts "Chicken, cluck, cluck"
puts "_____________"
puts "_____________"
get_recipes(url)
