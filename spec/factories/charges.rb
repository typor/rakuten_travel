# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge do
    hotel nil
    room nil
    plan ""
    stay_day ""
    prace ""
  end
end
