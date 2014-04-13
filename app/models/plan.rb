class Plan < ActiveRecord::Base
  belongs_to :hotel
  validates :hotel_id, presence: true
  validates :code, presence: true, numericality: true
  validates :long_name, presence: true, length: { maximum: 500 }
  validates :short_name, length: { maximum: 64 }
  validates :description, length: { maximum: 3000 }
  validates :payment_code, presence: true, inclusion: { in: [0, 1, 2] }
  validates :point_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 100 }
  validates :with_dinner, inclusion: {in: [true, false]}
  validates :with_breakfast, inclusion: {in: [true, false]}

  def name
    short_name.presence || long_name
  end

  def self.payment_codes
    {
      I18n.t('global.cash_only') => 0,
      I18n.t('global.creditcard_only') => 1,
      I18n.t('global.cash_and_creditcard') => 2
    }
  end

  def self.safe_keys(refresh = false)
    if refresh || !(defined? @@safe_keys)
      @@safe_keys = new.attributes.keys.select{|k, v| %w(id created_at updated_at).include?(k) != true }
    end
    @@safe_keys
  end
end
