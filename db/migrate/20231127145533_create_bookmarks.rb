class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.boolean :cooked_status
      t.text :notes
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
