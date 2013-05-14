# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cameo do
    video_id 1
    user_id 1
    director_id 1
    status "MyString"
    show_id 1
    show_order 1
  end
end
