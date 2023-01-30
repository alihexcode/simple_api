class RecipePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def filter?
    true
  end

  private

  def owner?
    user == record.user
  end
end
