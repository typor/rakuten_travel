# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    sequence(:code){|n| 1000 + n }
    long_name 'dummy'
    hotel { Hotel.first || create(:hotel) }
    point_rate 1
    with_dinner false
    with_breakfast false
  end
end
