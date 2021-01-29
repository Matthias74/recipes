class Ingredient < ApplicationRecord
  # Associations
  belongs_to :recipe

  # Validations
  validates :name, presence: true
  validates :recipe_id, presence: true
end
