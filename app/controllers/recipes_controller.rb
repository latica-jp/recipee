class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  skip_before_action :require_login, only: [:index, :show]

  def index
    @recipes = Recipe.all 
  end
  
  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build.row_order = 1 # new ではなく build
    @recipe.recipe_steps.build.row_order = 1 # new ではなく build
  end
    
  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
        flash[:notice] = "レシピを保存しました。"
        render :edit
    else
        flash[:alert] = "レシピの保存に失敗しました。"
        render :new
    end
  end
  
  def edit
  end
  
  def clip
    url = params[:clip_url]
    # view_context ヘルパーメソッドの呼び出しに使える
    clipper = view_context.create_clipper(url)
    if clipper.present?
      @recipe = Recipe.new(clipper.recipe_params)
      if @recipe.save
          flash[:notice] = "レシピを取得して保存しました。"
          redirect_to @recipe
      else
          flash[:alert] = "レシピを取得しましたが、保存に失敗しました。"
          render :edit
      end
    else
      flash[:alert] = "レシピデータが取得できませんでした。URLを確認してください。"
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

  def recipe_params
    params.require(:recipe).permit(:id, :title, :author_name, :ref_url, 
      :main_photo_url, :description, :servings_for, 
      :image, :image_cache, :remove_image, :clip_url, 
      recipe_ingredients_attributes: [:id, :name, :quantity_for, 
        :order, :row_order, :_destroy],
      recipe_steps_attributes: [:id, :text, :photo_url, :position, :row_order,
        :image, :remove_image, :image_cache, :_destroy])
  end
end
