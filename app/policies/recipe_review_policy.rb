class RecipeReviewPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def create?
    true
  end

  private

  def owner?
    user == record.user
  end
end
