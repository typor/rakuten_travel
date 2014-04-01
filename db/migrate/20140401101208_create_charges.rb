class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.belongs_to :hotel, index: true
      t.belongs_to :room, index: true
      t.belongs_to :plan, index: true
      t.integer :stay_day
      t.integer :amount
      t.timestamps
    end
  end
end
