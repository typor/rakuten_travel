# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :area do
    sequence(:long_name){|n| "Area#{n}" }
    sequence(:short_name){|n| "Area#{n}" }
    large "japan"
    middle "tokyo"
    small "tokyo"
    sequence(:detail){|n| n }
    enabled true
  end
end
