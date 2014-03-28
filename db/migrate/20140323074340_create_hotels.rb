class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.integer :area_id, null: false
      t.string :no, length: 64, null: false, unique: true
      t.string :name, length: 255, null: false
      t.string :postal_code, length: 8, null: false
      t.string :address1, length: 64, null: false
      t.string :address2, length: 255, null: false
      t.string :telephone_no, length: 32, null: false
      t.text :image_url
      t.text :url
      t.text :access
      t.timestamps
    end
  end
end
