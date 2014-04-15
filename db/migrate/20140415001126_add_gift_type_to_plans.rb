class AddGiftTypeToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :gift_type, :integer
    rename_column :plans, :quo, :gift_price
  end
end
