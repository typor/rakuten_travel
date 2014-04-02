class CreateChargeHistories < ActiveRecord::Migration
  def change
    create_table :charge_histories do |t|
      t.belongs_to :charge, index: true
      t.datetime :researched_at, null: false
      t.integer :amount, default: 0, null: false
      t.boolean :can_stay, default: true, null: false
    end
  end
end
