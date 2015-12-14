# == Schema Information
#
# Table name: recipe_steps
#
#  id         :integer          not null, primary key
#  recipe_id  :integer
#  text       :string
#  photo_url  :string
#  row_order  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class RecipeStepTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
