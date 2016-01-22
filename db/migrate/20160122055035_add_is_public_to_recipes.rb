class AddIsPublicToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :is_public, :boolean, default: false, null: false
  end
end
