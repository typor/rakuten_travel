# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hotel do
    area { Area.first || create(:area) }
    sequence(:no){|n| "123#{n}" }
    long_name 'dummy'
    postal_code '123-4567'
    address1 '東京都'
    address2 '渋谷区'
    telephone_no '03-1234-5678'
    hotel_image_url 'http://example.com/example.png'
    url 'http://example.com/'
    access 'dummy'
    enabled true
  end
end
