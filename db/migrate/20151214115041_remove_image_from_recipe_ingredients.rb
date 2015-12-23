class RemoveImageFromRecipeIngredients < ActiveRecord::Migration
  def change
    remove_column :recipe_ingredients, :image, :string
  end
end
