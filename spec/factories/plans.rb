# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    hotel { Hotel.first || create(:hotel) }
    point_rate 1
    with_dinner false
    with_breakfast false
    after(:build) {|plan|
      plan.room = Room.first || create(:room)
      plan.hotel = plan.room.hotel
    }
  end
end
