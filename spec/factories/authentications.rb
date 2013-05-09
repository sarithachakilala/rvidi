# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    user_id 1
    uid "MyString"
    provider "MyString"
    oauth_token "MyString"
    oauth_expires_at "2013-05-08 15:09:40"
  end
end
