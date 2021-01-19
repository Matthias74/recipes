class Recipe < ApplicationRecord
  serialize :ingredients, Array
  serialize :tags, Array
  serialize :cleaned_ingredients, Array
  serialize :cleaned_ingredient_ids, Array
end
