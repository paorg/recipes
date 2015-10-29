class RecipesController < ApplicationController

  before_action :find_recipe, only: [:show, :edit, :udpate, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_permission, only: [:edit, :destroy]

  def index
    @recipe = Recipe.all.order("created_at DESC")
  end

  def show
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "Successfully created new recipe!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update

    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render 'edit'
    end

  end

  def destroy
    @recipe.destroy
    redirect_to root_path, notice: "Successsfully deleted recipe"
  end

  def require_permission
    if current_user != Recipe.find(params[:id]).user
      flash[:notice] = "You can't make changes to a recipe that you don't own."
      render 'show'
    end
  end
  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :image, 
     ingredients_attributes:[:id, :name, :_destroy],
     directions_attributes: [:id, :step, :_destroy])

  end


  def find_recipe
    @recipe = Recipe.find(params[:id])
  end


end
