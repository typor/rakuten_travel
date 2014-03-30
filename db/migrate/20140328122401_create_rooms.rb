class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.belongs_to :hotel, null: false
      t.string :code, length: 32, null: false
      t.string :name, length: 255, null: false
      t.boolean :smoking, default: false, null: false
      t.timestamps
    end
  end
end
