class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.belongs_to :hotel, index: true
      t.belongs_to :room, index: true
      t.integer :code, null: false
      t.string :name, null: false, length: 255
      t.integer :payment_code, null: false, default: 1
      t.text :description
      t.integer :point_rate, default: 0
      t.boolean :with_dinner, default: false
      t.boolean :with_breakfast, default: false

      t.timestamps
    end
  end
end
