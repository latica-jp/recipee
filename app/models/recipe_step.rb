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
#  image      :string
#

class RecipeStep < ActiveRecord::Base
  belongs_to :recipe

  mount_uploader :image, ImageUploader

  validates :text, length: {maximum: 256}, presence: true
end
