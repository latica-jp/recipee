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

class RecipeStep < ActiveRecord::Base
  belongs_to :recipe

  validates :text, presence: true, length: {mimimum: 1, maximum: 50}
end
