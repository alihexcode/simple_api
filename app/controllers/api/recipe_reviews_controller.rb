module Api
  class RecipeReviewsController < Api::BaseController
    before_action :doorkeeper_authorize!, only: %i[create update destroy]
    before_action :current_user_authenticate, only: %i[create update destroy]
    before_action :set_recipe_review, only: %i[show update destroy]

    # POST /api/recipe_reviews
    def create
      @recipe_review = authorize RecipeReview.new(review_params)
      @recipe_review.user = current_user
      @recipe_review.save!
    end

    # GET /api/recipe_reviews/:id
    def show; end

    # PUT /api/recipe_reviews/:id
    def update
      @recipe_review.update!(review_params)
    end

    # DELETE /api/recipe_reviews/:id
    def destroy
      @recipe_review.destroy
    end

    private

    def set_recipe_review
      @recipe_review = RecipeReview.find(params[:id])
      authorize @recipe_review
    end

    def review_params
      params.require(:recipe_review).permit(:review, :rating, :recipe_id)
    end
  end
end
