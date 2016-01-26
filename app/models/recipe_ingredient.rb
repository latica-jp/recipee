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

class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe

  validates :name, presence: true, length: {maximum: 100}
  before_save -> {
    response = HTTParty.post("https://labs.goo.ne.jp/api/hiragana", body: { app_id: Rails.application.secrets.goo_lab_api_key, sentence: self.name, output_type: "hiragana" })
    self.name_hiragana = response["converted"]
  }
end
