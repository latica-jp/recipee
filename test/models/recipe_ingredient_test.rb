# == Schema Information
#
# Table name: recipe_ingredients
#
#  id            :integer          not null, primary key
#  recipe_id     :integer
#  name          :string
#  quantity_for  :string
#  row_order     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name_hiragana :string
#

require 'test_helper'

class RecipeIngredientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
