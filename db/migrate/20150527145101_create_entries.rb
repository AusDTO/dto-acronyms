class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :term, null: false
      t.string :expanded_term
      t.text :definition

      t.timestamps null: false
    end
  end
end
