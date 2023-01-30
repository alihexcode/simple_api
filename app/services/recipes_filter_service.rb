# The `RecipeFilterService` is a service object that allows you to filter a list of recipes by various criteria.

class RecipesFilterService
  # Initializes a new instance of the service.
  #
  # @param params [Hash] A hash of query parameters to filter the recipes by.
  # @option params [String] :title A string to filter the recipes by title.
  # @option params [Integer] :time_from The start time (in minutes) to filter the recipes by time range. Example values: 60, 10, 40
  # @option params [Integer] :time_to The end time (in minutes) to filter the recipes by time range. Example values: 60, 10, 40
  # @option params [String] :difficulty A string to filter the recipes by difficulty. Accepts one of the following values: 'easy', 'normal', or 'challenging'.
  def initialize(params)
    @params = params
  end

  # Filters a list of recipes by the specified criteria.
  #
  # @return [Array<Recipe>] An array of matching recipes.
  def call
    recipes = Recipe.includes(:ingredients, :recipe_reviews)
    recipes = filter_by_title(recipes)
    recipes = filter_by_time(recipes)
    filter_by_difficulty(recipes)
  end

  private

  def filter_by_title(recipes)
    return recipes unless @params[:title]

    recipes.where('lower(title) LIKE ?', "%#{@params[:title]}%")
  end

  def filter_by_time(recipes)
    return recipes unless @params[:time_from] && @params[:time_to]

    validate_time_range
    recipes.where(time: @params[:time_from]..@params[:time_to])
  end

  def filter_by_difficulty(recipes)
    return recipes unless @params[:difficulty]

    recipes.where(difficulty: @params[:difficulty])
  end

  # Validates the time range filter.
  #
  # Raises an error if the time range is invalid (i.e. time_from > time_to).
  def validate_time_range
    return unless @params[:time_from] && @params[:time_to]

    raise ArgumentError, 'Invalid time range: time_from must be less than or equal to time_to' if @params[:time_from].to_i > @params[:time_to].to_i
  end
end
