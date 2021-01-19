json.recipes @recipes do |recipe|
  json.name        recipe.name
  json.rate        recipe.rate
  json.author_tip  recipe.author_tip
  json.budget      recipe.budget
  json.prep_time   recipe.prep_time
  json.ingredients recipe.ingredients
  json.difficulty  recipe.difficulty
  json.cook_time   recipe.cook_time
  json.tags        recipe.tags
  json.cleaned_ingredients recipe.cleaned_ingredients
  json.people_quantity     recipe.people_quantity
end

json.total_pages   @recipes.total_pages
json.current_page  @recipes.current_page

