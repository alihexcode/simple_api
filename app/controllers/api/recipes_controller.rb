class Api::RecipesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update destroy create]
  before_action :current_user_authenticate, only: %i[update destroy create]
  before_action :set_recipe, only: %i[show update destroy]
  after_action :paginate, only: %i[index filter]

  def index
    @recipes = authorize Recipe.includes(Recipe.associations)
    @pagy, @recipes = pagy(@recipes, page: params.fetch(:page, 1), items: params.fetch(:per_page, 10))
  end

  def show; end

  def create
    @recipe = authorize Recipe.create!(recipe_params)
  end

  def update
    @recipe.update!(recipe_params)
  end

  def destroy
    @recipe.destroy!
  end

  def filter
    filter = RecipesFilterService.new(params)

    @pagy, @recipes = pagy(filter.call, page: params.fetch(:page, 1), items: params.fetch(:per_page, 10))
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :descriptions, :time, :difficulty, :category_id, :user_id).tap do |p|
      p[:user_id] = current_user.id
    end
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
    authorize @recipe
  end
end
