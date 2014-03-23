class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name, length: 32, null: false
      t.string :large, length: 32, null: false
      t.string :middle, length: 32, null: false
      t.string :small, length: 32
      t.string :detail, length: 16
      t.timestamps
    end
  end
end
