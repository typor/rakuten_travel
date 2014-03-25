class Hotel < ActiveRecord::Base
  validates :no, presence: true, uniqueness: true, length: { maximum: 64 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :postal_code, presence: true, length: { maximum: 8 }
  validates :address1, presence: true, length: { maximum: 64 }
  validates :address2, presence: true, length: { maximum: 255 }
  validates :telephone_no, presence: true, length: { maximum: 32 }
  validates :image_url, presence: true, length: { maximum: 512 }
  validates :url, presence: true, length: { maximum: 512 }
  validates :access, presence: true

  def from_api(response)
    api_map.each_pair do |k,v|
      next unless response.key?(k)
      self.send("#{v}=", response[k])
    end
    self
  end

  def api_map
    {
      "hotelNo" => :no,
      "hotelName" => :name,
      "postalCode" => :postal_code,
      "address1" => :address1,
      "address2" => :address2,
      "telephoneNo" => :telephone_no,
      "access" => :access,
      "hotelImageUrl" => :image_url,
      "hotelInformationUrl" => :url
    }
  end
end
