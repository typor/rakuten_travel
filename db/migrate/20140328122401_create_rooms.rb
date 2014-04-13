class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.belongs_to :hotel, null: false
      t.string :code, length: 32, null: false
      t.string :long_name, length: 255, null: false
      t.string :short_name, length: 32
      t.boolean :smoking, default: false, null: false
      t.boolean :ladies, default: false, null: false
      t.boolean :enabled, default: true, null: false
      t.timestamps
    end
  end
end
