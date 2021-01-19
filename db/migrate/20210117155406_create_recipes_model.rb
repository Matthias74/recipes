class CreateRecipesModel < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.integer :rate
      t.text :author_tip
      t.string :budget
      t.string :prep_time
      t.text :ingredients
      t.string :name
      t.string :author
      t.string :difficulty
      t.integer :people_quantity
      t.string :cook_time
      t.text :tags
      t.string :total_time
      t.text :nb_comments
      t.text :cleaned_ingredients
      t.text :cleaned_ingredient_ids

      t.timestamps

      t.index :name
    end
  end
end
