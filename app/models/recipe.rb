# == Schema Information
#
# Table name: recipes
#
#  id             :integer          not null, primary key
#  title          :string
#  author_name    :string
#  ref_url        :string
#  main_photo_url :string
#  description    :string
#  servings_for   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image          :string
#  user_id        :integer
#  is_public      :boolean          default(FALSE), not null
#

class Recipe < ActiveRecord::Base
  acts_as_taggable_on :tags
  acts_as_votable
  belongs_to :users

  has_many :recipe_ingredients, -> { order(:row_order) }, dependent: :destroy
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  has_many :recipe_steps, -> { order(:row_order) }, dependent: :destroy
  accepts_nested_attributes_for :recipe_steps, allow_destroy: true

  mount_uploader :image, ImageUploader

  validates :title, presence: true, length: {minimum: 2, maximum: 50}

  def is_public_and_created_by_others
    is_public && user_id != current_user
  end

  def is_clipped?
    ref_url.present?
  end
end
