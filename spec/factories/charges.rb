# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge do
    stay_day { 0.days.since.strftime('%Y%m%d') }
    amount 1000
    can_stay true
  end
end
