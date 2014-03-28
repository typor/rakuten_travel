class Hotel < ActiveRecord::Base
  validates :area_id, presence: true
  validates :no, presence: true, uniqueness: true, length: { maximum: 64 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :postal_code, presence: true, length: { maximum: 8 }
  validates :address1, presence: true, length: { maximum: 64 }
  validates :address2, presence: true, length: { maximum: 255 }
  validates :telephone_no, presence: true, length: { maximum: 32 }
  validates :image_url, presence: true, length: { maximum: 512 }, url: true
  validates :url, presence: true, length: { maximum: 512 }, url: true
  validates :access, presence: true

  belongs_to :area

  def safe_keys
    self.attributes.keys.select{|k, v| %w(id created_at updated_at).include?(k) != true }
  end

end
