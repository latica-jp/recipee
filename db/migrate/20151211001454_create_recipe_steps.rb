class CreateRecipeSteps < ActiveRecord::Migration
  def change
    create_table :recipe_steps do |t|
      t.references :recipe, index: true, foreign_key: true
      t.string :text
      t.string :photo_url
      t.integer :position

      t.timestamps null: false
    end
  end
end
