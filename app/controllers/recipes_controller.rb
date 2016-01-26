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

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  before_action :set_is_public, only: [:index, :show]
  before_action :is_self_owned, only: [:edit, :update, :destroy]
  before_action :is_self_owned_or_public, only: [:show]
  skip_before_action :require_login, only: [:show, :index]

  def index
    @q = Recipe.ransack(params[:q])
    if @is_public || !current_user
      @recipes = @q.result(distinct: true).where(is_public: true)
    else
      @recipes = @q.result(distinct: true).where(user_id: current_user.id)
    end
    set_all_tags(@recipes)
    @recipes = @recipes.tagged_with(params[:tag]) if params[:tag]
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

  def show
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

  def set_is_public
    @is_public = (params.try(:[], :recipe).try(:[], :is_public)) == "true"
  end

  def set_all_tags(recipes)
    @tags = Set.new
    recipes.each { |recipe| @tags.merge(recipe.tag_list) }
  end

  def is_self_owned
    redirect_to root_path unless @recipe.user_id == current_user.id
  end

  def is_self_owned_or_public
    redirect_to root_path unless @recipe.is_public || @recipe.user_id == current_user.id
  end

  def recipe_params
    params.require(:recipe).permit(:id, :user_id, :title, :author_name, :ref_url,
      :main_photo_url, :description, :servings_for,
      :image, :image_cache, :remove_image, :clip_url, :tag_list,
      :tag, :is_public,
      recipe_ingredients_attributes: [:id, :name, :quantity_for,
        :order, :row_order, :_destroy],
      recipe_steps_attributes: [:id, :text, :photo_url, :position, :row_order,
        :image, :remove_image, :image_cache, :_destroy])
  end
end
