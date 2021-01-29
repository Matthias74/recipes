json.recipes @recipes do |recipe|
  json.id          recipe.id
  json.name        recipe.name
  json.rate        recipe.rate
  json.author_tip  recipe.author_tip
  json.budget      recipe.budget
  json.prep_time   recipe.prep_time
  json.difficulty  recipe.difficulty
  json.cook_time   recipe.cook_time
  json.tags        recipe.tags
  json.people_quantity     recipe.people_quantity

  json.ingredients recipe.ingredients do |ingredient|
    json.id   ingredient.id
    json.name ingredient.name
  end
end

json.total_pages   @recipes.total_pages
json.current_page  @recipes.current_page

