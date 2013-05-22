# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "jyothis"
    email "jyothis.kalangi@gmail.com"
    password "password"
    password_confirmation "password"
  end
end
