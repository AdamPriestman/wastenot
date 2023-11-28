class AddColumnsToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :preptime, :integer
    change_column :recipes, :cooktime, :integer
    add_column :recipes, :servings, :integer
    add_column :recipes, :source, :string
  end
end
