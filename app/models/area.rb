class Area < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 255 }
  validates :large, presence: true, length: { maximum: 32 }
  validates :middle, presence: true, length: { maximum: 16 }, uniqueness: {scope: [:middle, :small, :detail]}
  validates :small, length: { maximum: 16 }
  validates :detail, length: { maximum: 16 }

  def to_api_params
    {
      largeClassCode: large,
      middleClassCode: middle,
      smallClassCode: small,
      detailClassCode: detail
    }.delete_if{|k, v| v.nil? }
  end
end
