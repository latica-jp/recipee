class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  skip_before_action :require_login, only: [:index, :show]

  include RecipesHelper

  def index
    # ranked-model を使用してソート…するにはどうしたらいいのか
    @recipes = Recipe.all 
  end
  
  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build.row_order = 1 # new ではなく build を使う
    @recipe.recipe_steps.build.row_order = 1 # new ではなく build を使う
  end
    
  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
        flash[:notice] = "Saved"
        redirect_to @recipe
    else
        flash[:alert] = "Couldn't Save"
        render :new
    end
  end
  
  def clip
    url = params[:clip_url]
binding.pry
    clipper = Clipper.new(url)
    @recipe = Recipe.new(clipper.recipe_params)
    if @recipe.save
        flash[:notice] = "Saved"
        redirect_to @recipe
    else
        flash[:alert] = "Couldn't Save"
        render :new
    end
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:notice] = "updated"
      redirect_to root_path
    else
      flash[:alert] = "save error"
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
      :clip_url,
      recipe_ingredients_attributes: [:id, :name, :quantity_for, :order, :row_order, :_destroy],
      recipe_steps_attributes: [:id, :text, :photo_url, :position, :row_order, :image, :remove_image, :image_cache, :_destroy])
  end

end
