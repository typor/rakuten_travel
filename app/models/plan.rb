class Plan < ActiveRecord::Base
  extend Enumerize

  belongs_to :hotel
  validates :hotel_id, presence: true
  validates :code, presence: true, numericality: true
  validates :long_name, presence: true, length: { maximum: 500 }
  validates :short_name, length: { maximum: 64 }
  validates :description, length: { maximum: 3000 }
  validates :payment_code, presence: true, inclusion: { in: [0, 1, 2] }
  validates :point_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 100 }
  validates :gift_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :with_dinner, inclusion: {in: [true, false]}
  validates :with_breakfast, inclusion: {in: [true, false]}

  scope :enabled, -> { where(enabled: true) }
  enumerize :gift_type, in: {none: 0, quocard: 1, others: 999 }, predicates: { prefix: true }

  def name
    short_name.presence || long_name
  end

  class << self
    def zen_to_han(value)
      value.to_s.tr("０-９Ａ-Ｚａ-ｚ，￥", "0-9A-Za-z,¥")
    end

    # 文字列中から特典情報を取り出します。
    def parse_gift(value)
      value = zen_to_han(value).gsub(/ 　/, "")
      v = /\¥([1-9][\d\,]+)/.match(value) || /([1-9][\d\,]+)円/.match(value)
      return {gift_type: :none, gift_price: 0 } if v.nil?

      v = v.captures.first.gsub(',', '').to_i
      value.downcase!
      %w(quo クオ).each do |f|
        return {gift_type: :quocard, gift_price: v} if value.include? f
      end
      {gift_type: :others, gift_price: v}
    end

    def payment_codes
      {
        I18n.t('global.cash_only') => '0',
        I18n.t('global.cash_and_creditcard') => '1',
        I18n.t('global.creditcard_only') => '2'
      }
    end

    def safe_keys(refresh = false)
      if refresh || !(defined? @@safe_keys)
        @@safe_keys = new.attributes.keys.select{|k, v| %w(id created_at updated_at).include?(k) != true }
      end
      @@safe_keys
    end

    def gift_types
    end
  end
end
