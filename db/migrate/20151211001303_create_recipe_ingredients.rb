class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, index: true, foreign_key: true
      t.string :name
      t.string :quantity_for
      t.integer :order

      t.timestamps null: false
    end
  end
end
