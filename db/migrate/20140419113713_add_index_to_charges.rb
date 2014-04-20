class AddIndexToCharges < ActiveRecord::Migration
  def change
    add_index(:charges, :stay_day)
  end
end
