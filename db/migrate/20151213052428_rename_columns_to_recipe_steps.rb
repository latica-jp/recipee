class RenameColumnsToRecipeSteps < ActiveRecord::Migration
  def change
    rename_column :recipe_steps, :position, :row_order
  end
end
