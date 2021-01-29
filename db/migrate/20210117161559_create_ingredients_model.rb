class CreateIngredientsModel < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :recipe_id
      t.timestamps

      t.index :name
    end
  end
end
