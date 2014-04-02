class ChargeHistory < ActiveRecord::Base
  belongs_to :charge
  validates :charge_id, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
