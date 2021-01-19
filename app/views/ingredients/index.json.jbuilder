json.ingredients @ingredients do |ingredient|
  json.name ingredient.name
  json.id ingredient.id
end

json.total_pages  @ingredients.total_pages
json.current_page @ingredients.current_page
