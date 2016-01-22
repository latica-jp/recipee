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
#

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  skip_before_action :require_login, only: [:show]

  def index
    @recipes = current_user.recipes
    set_all_tags
  end

  def tag
    @recipes = current_user.recipes.tagged_with(params[:tag])
    set_all_tags
    render :index
  end

  def new
    @recipe = current_user.recipes.new
    @recipe.recipe_ingredients.build.row_order = 1 # new ではなく build
    @recipe.recipe_steps.build.row_order = 1 # new ではなく build
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
        flash[:notice] = "レシピを保存しました。"
        redirect_to @recipe
    else
        flash[:alert] = "レシピの保存に失敗しました。"
        render :new
    end
  end

  def edit
  end

  def destroy
    if @recipe.destroy
      flash[:notice] = "レシピを削除しました。"
      redirect_to root_path
    else
      flash[:alert] = "レシピの削除に失敗しました。"
      # えっと？
    end
  end

  def clip
    url = params[:clip_url]
    # view_context経由でヘルパーメソッドの呼び出し
    clipper = view_context.create_clipper(url)
    if clipper.present?
      @recipe = current_user.recipes.new(clipper.recipe_params)
      if @recipe.save
          flash[:notice] = "外部レシピを取得して保存しました。"
          redirect_to @recipe
      else
          flash[:alert] = "外部レシピを取得しましたが、保存に失敗しました。"
          render :edit
      end
    else
      flash[:alert] = "外部レシピデータが取得できませんでした。URLを確認してください。"
      redirect_to new_recipe_path
    end
  end

  def update
    if @recipe.update(recipe_params)
      flash[:notice] = "レシピを更新しました。"
      redirect_to @recipe
    else
      flash[:alert] = "レシピの更新に失敗しました。"
      render :edit
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_all_tags
    @tags = Set.new
    current_user.recipes.each { |recipe| @tags.merge(recipe.tag_list) }
  end

  def recipe_params
    params.require(:recipe).permit(:id, :user_id, :title, :author_name, :ref_url,
      :main_photo_url, :description, :servings_for,
      :image, :image_cache, :remove_image, :clip_url, :tag_list,
      recipe_ingredients_attributes: [:id, :name, :quantity_for,
        :order, :row_order, :_destroy],
      recipe_steps_attributes: [:id, :text, :photo_url, :position, :row_order,
        :image, :remove_image, :image_cache, :_destroy])
  end
end
