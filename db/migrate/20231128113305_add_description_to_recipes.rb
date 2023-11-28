class AddDescriptionToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :description, :text
  end
end
