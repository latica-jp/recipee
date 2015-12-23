class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :author_name
      t.string :ref_url
      t.string :main_photo_url
      t.string :description
      t.string :servings_for

      t.timestamps null: false
    end
  end
end
