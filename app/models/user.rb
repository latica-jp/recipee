# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string           not null
#  crypted_password             :string
#  salt                         :string
#  created_at                   :datetime
#  updated_at                   :datetime
#  remember_me_token            :string
#  remember_me_token_expires_at :datetime
#  name                         :string
#

class User < ActiveRecord::Base
    has_many :recipes, -> { order(updated_at: :desc) }, dependent: :destroy

    # 公式ドキュメント通りに記述。
    # if: -> は　:if => lambda{..} と等価
    authenticates_with_sorcery!

    validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
    validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
    validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

    validates :email, uniqueness: true
end
