class AddImageToRecipeSteps < ActiveRecord::Migration
  def change
    add_column :recipe_steps, :image, :string
  end
end
