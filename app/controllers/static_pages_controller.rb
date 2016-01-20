class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: [:home]
  def home
    if current_user
      redirect_to recipes_path
    end
  end
end
