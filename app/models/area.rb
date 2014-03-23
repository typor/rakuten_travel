class Area < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :large, presence: true, length: { maximum: 32 }
  validates :middle, presence: true, length: { maximum: 32 }
  validates :small, length: { maximum: 32 }
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
