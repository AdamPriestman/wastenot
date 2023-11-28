class RenameCusineToCuisine < ActiveRecord::Migration[7.1]
  def change
    rename_column :recipes, :cusine, :cuisine
  end
end
