class AddNameHiraganaToRecipeIngredients < ActiveRecord::Migration
  def change
    add_column :recipe_ingredients, :name_hiragana, :string
  end
end
