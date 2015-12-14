class AddImageToRecipeIngredients < ActiveRecord::Migration
  def change
    add_column :recipe_ingredients, :image, :string
  end
end
