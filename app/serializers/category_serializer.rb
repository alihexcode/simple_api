class CategorySerializer < BaseSerializer
  attributes :id, :created_at, :updated_at, :description

  has_many :recipes
end
