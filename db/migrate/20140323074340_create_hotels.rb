class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.integer :area_id, null: false
      t.string :no, length: 64, null: false, unique: true
      t.string :long_name, length: 255, null: false
      t.string :short_name, lenght: 32
      t.string :postal_code, length: 8, null: false
      t.string :address1, length: 64, null: false
      t.string :address2, length: 255, null: false
      t.string :telephone_no, length: 32, null: false
      t.boolean :enabled, default: false
      t.text :url
      t.text :hotel_image_url
      t.text :room_image_url
      t.text :review_url
      t.text :access
      t.string :latitude, length: 16
      t.string :longitude, length: 16
      t.integer :room_num, default: 0
      t.integer :review_count, default: 0
      t.integer :review_average, default: 0
      t.integer :service_average, default: 0
      t.integer :location_average, default: 0
      t.integer :room_average, default: 0
      t.integer :equipment_average, default: 0
      t.integer :bath_average, default: 0
      t.integer :meal_average, default: 0
      t.timestamps
    end
  end
end
