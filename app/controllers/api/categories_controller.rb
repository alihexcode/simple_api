class Api::CategoriesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create update destroy]
  before_action :current_user_authenticate, only: %i[create update destroy]
  before_action :set_category, only: %i[show update destroy]
  after_action :paginate, only: :index

  # GET /api/categories
  def index
    @categories = authorize Category.includes(Category.associations)
    @pagy, @categories = pagy(@categories, page: params[:page] || 1, items: params[:per_page])
  end

  # GET /api/categories/:id
  def show; end

  # POST /api/categories
  def create
    @category = authorize Category.create!(category_params)
  end

  # PUT /api/categories/:id
  def update
    @category.update!(category_params)
  end

  # DELETE /api/categories/:id
  def destroy
    @category.destroy!
  end

  private

  def set_category
    @category = Category.includes(:recipes, :ingredients).find(params[:id])
    authorize @category
  end

  def category_params
    params.require(:category).permit(:description)
  end
end
