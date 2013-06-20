# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite_friend do
    director_id 1
    show_id 1
    contributor_id 1
    status "MyString"
  end
end
