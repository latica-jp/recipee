class UserSessionsController < ApplicationController
  before_action :require_login, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember])
      redirect_back_or_to controller: :recipes, action: :index
    else
      flash.now[:alert] = "ログインに失敗しました。"
      render "new"
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
