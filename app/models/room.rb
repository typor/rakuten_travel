class Room < ActiveRecord::Base
  validates :hotel_id, presence: true
  validates :code, presence: true, length: { maximum: 32 }, uniqueness: { scope: :hotel_id }
  validates :name, presence: true, length: { maximum: 255 }
  validates :smoking, inclusion: {in: [true, false]}
  belongs_to :hotel

  def self.safe_keys(refresh = false)
    if refresh || !(defined? @@safe_keys)
      @@safe_keys = new.attributes.keys.select{|k, v| %w(id created_at updated_at).include?(k) != true }
    end
    @@safe_keys
  end
end
