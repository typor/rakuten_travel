class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.belongs_to :hotel, index: true
      t.integer :code, null: false
      t.text :long_name
      t.string :short_name, length: 32
      t.integer :payment_code, null: false, default: 1
      t.text :description
      t.integer :point_rate, default: 0, null: false
      t.boolean :with_dinner, default: false, null: false
      t.boolean :with_breakfast, default: false, null: false
      t.integer :quo, default: 0, null: false
      t.boolean :enabled, default: true, null: false
      t.timestamps
    end
  end
end
