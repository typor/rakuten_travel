class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name, length: 255, null: false
      t.string :large, length: 16, null: false
      t.string :middle, length: 16, null: false
      t.string :small, length: 16
      t.string :detail, length: 16
      t.timestamps
    end
    add_index :areas, [:middle, :small, :detail], unique: true
  end
end
