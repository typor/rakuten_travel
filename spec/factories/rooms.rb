# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    hotel { Hotel.first || create(:hotel) }
    sequence(:code){|n| "123#{n}" }
    name 'dummy'
    smoking true
  end
end
