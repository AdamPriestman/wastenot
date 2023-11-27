class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :cusine
      t.string :course
      t.text :instructions
      t.float :cooktime

      t.timestamps
    end
  end
end
