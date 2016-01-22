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

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :new, :create]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        auto_login(@user)
        redirect_to root_path, notice: 'ユーザを新規作成しました。'
      else
        render :new
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to recipes_path, notice: 'ユーザ情報を変更しました。'
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
end
