class Recipe < ApplicationRecord
  has_many :ingredients

  serialize :tags, Array
end
