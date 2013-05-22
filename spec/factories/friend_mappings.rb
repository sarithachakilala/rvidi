# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :friend_mapping do
    user_id 1
    friend_id 1
    status "MyString"
  end
end
