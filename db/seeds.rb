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
  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    username: Faker::FunnyName.two_word_name.delete(" "),
    email: "chef#{i + 1}@email.com",
    password: "password"
  )
  user.save!
  puts "User #{i + 1} created"
end

url = URI("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=pasta&cuisine=italian&instructionsRequired=true&fillIngredients=false&addRecipeInformation=true&ignorePantry=true&number=30&limitLicense=false")

# 30 pasta results no ingredients passed

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
  instructions_string = []
  instructions = recipe["analyzedInstructions"]
  instructions.each do |recipe_instructions|
    steps = recipe_instructions["steps"]
    steps.each do |step|
      instructions_string.push("#{step['number']}.#{step['step'].gsub(/<\/?.>/, '')}")
    end
  end
  local_recipe = Recipe.create(
    title: recipe["title"],
    preptime: recipe["preparationMinutes"],
    cooktime: recipe["cookingMinutes"],
    cuisine: recipe["cuisines"].join(", "),
    course: recipe["dishTypes"].join(", "),
    description: recipe["summary"].gsub(/<\/?.>/, ""),
    instructions: instructions_string,
    servings: recipe["servings"],
    source: recipe["creditsText"],
    image: recipe["image"],
    vegan: recipe["vegan"],
    vegetarian: recipe["vegetarian"],
    gluten_free: recipe["glutenFree"],
    dairy_free: recipe["dairyFree"]
  )
  puts "Recipe #{recipe_counter} created"

  instructions.each do |instruction|
    steps = instruction["steps"]
    steps.each do |step|
      ingredients = step["ingredients"]
      ingredients.each do |ingredient|
        existing_ingredients = Ingredient.where("name=?", ingredient["name"])
        if existing_ingredients.empty?
          local_ingredient = Ingredient.create(name: ingredient["name"])
        else
          local_ingredient = existing_ingredients.first
        end
        recipe_ingredient = RecipeIngredient.new
        recipe_ingredient.ingredient = local_ingredient
        recipe_ingredient.recipe = local_recipe
        recipe_ingredient.save!
      end
    end
    puts "Ingredients added to recipe #{recipe_counter}"
  end

  recipe_counter += 1
end
