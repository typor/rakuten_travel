class Hotel < ActiveRecord::Base
  validates :area_id, presence: true
  validates :no, presence: true, uniqueness: true, length: { maximum: 64 }
  validates :long_name, presence: true, length: { maximum: 255 }
  validates :short_name, length: { maximum: 32 }
  validates :postal_code, presence: true, length: { maximum: 8 }
  validates :address1, presence: true, length: { maximum: 64 }
  validates :address2, presence: true, length: { maximum: 255 }
  validates :telephone_no, presence: true, length: { maximum: 32 }
  validates :hotel_image_url, presence: true, length: { maximum: 512 }, url: true
  validates :url, presence: true, length: { maximum: 512 }, url: true
  validates :access, presence: true

  belongs_to :area
  has_many :plans
  has_many :gift_plans, -> { where(enabled: true).where('gift_price > 0').order(gift_price: :asc) }, class_name: 'Plan'
  has_many :rooms
  has_many :smoking_rooms, -> { where(enabled: true, smoking: true) }, class_name: 'Room'
  has_many :nonsmoking_rooms, -> { where(enabled: true, smoking: false) }, class_name: 'Room'
  has_many :ladies_rooms, -> { where(enabled: true, ladies: true) }, class_name: 'Room'
  has_many :charges

  scope :enabled, -> { where(enabled: true) }

  def name
    short_name.presence || long_name
  end

  def full_address
    address1 + address2
  end

  def uri_escaped_name
    URI.escape(name)
  rescue
    name
  end

  def minimum_charge(start = 30, finish = 30)
    ids = plans.where(enabled: true).ids
    Charge.where(plan_id: plans.where(enabled: true).ids)
      .within(start.days.ago.strftime('%Y%m%d'), finish.days.since.strftime('%Y%m%d')).minimum(:amount) || 0
  end

  def room_type_count
    @room_type_count ||= Room.where(hotel_id: self.id).count
  end

  def plan_count
    @plan_count ||= Plan.where(hotel_id: self.id).count
  end

  def toggle_enabled
    self.update(enabled: !self.enabled)
  end

  def self.safe_keys(refresh = false)
    if refresh || !(defined? @@safe_keys)
      @@safe_keys = new.attributes.keys.select{|k, v| %w(id created_at updated_at).include?(k) != true }
    end
    @@safe_keys
  end

end
