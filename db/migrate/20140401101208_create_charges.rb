class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.belongs_to :hotel, index: true
      t.belongs_to :room, index: true
      t.belongs_to :plan, index: true
      t.integer :stay_day, null: false
      t.integer :amount, default: 0, null: false
      t.boolean :can_stay, default: true, null: false
      t.timestamps
    end
    add_index(:charges, [:room_id, :plan_id, :stay_day], unique: true)
  end
end
