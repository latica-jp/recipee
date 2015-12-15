# == Schema Information
#
# Table name: recipe_ingredients
#
#  id           :integer          not null, primary key
#  recipe_id    :integer
#  name         :string
#  quantity_for :string
#  row_order    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe

  validates :name, presence: true, length: {mimimum: 1, maximum: 100}
end
