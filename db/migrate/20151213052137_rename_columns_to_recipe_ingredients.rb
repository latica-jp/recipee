class RenameColumnsToRecipeIngredients < ActiveRecord::Migration
  def change
    rename_column :recipe_ingredients, :order, :row_order
  end
end
