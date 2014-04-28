class Room < ActiveRecord::Base
  validates :hotel_id, presence: true
  validates :code, presence: true, length: { maximum: 32 }, uniqueness: { scope: :hotel_id }
  validates :long_name, presence: true, length: { maximum: 255 }
  validates :short_name, length: { maximum: 32 }
  validates_inclusion_of :smoking, :ladies, :enabled, in: [true, false]
  belongs_to :hotel

  scope :enabled, -> { where(enabled: true) }
  scope :ladies, -> { where(ladies: true) }
  scope :notladis, -> { where(ladies: false) }
  scope :smoking, -> { where(smoking: true) }
  scope :nonsmoking, -> { where(smoking: false) }

  def name
    short_name.presence || long_name
  end

  def self.safe_keys(refresh = false)
    if refresh || !(defined? @@safe_keys)
      @@safe_keys = new.attributes.keys.select{|k, v| %w(id created_at updated_at).include?(k) != true }
    end
    @@safe_keys
  end
end
