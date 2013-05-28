# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    body "Test Comment 01"
    user_id 1
    show_id 1
    user_name "TestUser01"
  end
end
