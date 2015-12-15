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

  validates :text, presence: true, if: "image.nil?"
  validates :text, length: {mimimum: 1, maximum: 256}
end
