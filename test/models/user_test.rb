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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
