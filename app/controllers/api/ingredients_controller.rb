class Api::IngredientsController < Api::BaseController
  before_action :set_ingredient, only: %i[destroy update show convert]
  before_action :doorkeeper_authorize!, only: %i[create update destroy]
  before_action :current_user_authenticate, only: %i[create update destroy]
  after_action :paginate, only: :index

  def index
    @ingredients = authorize Ingredient.all
    @pagy, @ingredients = pagy(@ingredients, page: params[:page] || 1, items: params[:per_page])
  end

  def show; end

  def create
    @ingredient = authorize Ingredient.create!(ingredient_params)
  end

  def update
    @ingredient.update!(ingredient_params)
  end

  def destroy
    @ingredient.destroy!
  end

  def convert
    to_unit = params[:to_unit]
    new_amount = Ingredient.convert(@ingredient.amount, @ingredient.unit, to_unit)

    @ingredient.update!(amount: new_amount, unit: to_unit)
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:unit, :amount, :recipe_id)
  end

  def set_ingredient
    @ingredient = Ingredient.find(params[:id] || params[:ingredient_id])
    authorize @ingredient
  end
end
