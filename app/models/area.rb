class Area < ActiveRecord::Base
  after_initialize :init
  validates :long_name, presence: true, length: { maximum: 255 }
  validates :short_name, length: { maximum: 32 }
  validates :large, presence: true, length: { maximum: 32 }
  validates :middle, presence: true, length: { maximum: 16 }, uniqueness: {scope: [:middle, :small, :detail]}
  validates :small, length: { maximum: 16 }
  validates :detail, length: { maximum: 16 }

  scope :enabled, -> { where(enabled: true) }

  def init
    self.enabled ||= false if self.respond_to? :enabled
  end

  def name
    short_name || long_name
  end

  def uri_escaped_name
    URI.escape(name)
  rescue
    name
  end

  def to_api_params
    {
      largeClassCode: large,
      middleClassCode: middle,
      smallClassCode: small,
      detailClassCode: detail
    }.delete_if{|k, v| v.nil? }
  end
end
