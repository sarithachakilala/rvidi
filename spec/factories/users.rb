# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "rvidi_qwinix"
    email "rvidi.qwinix@yopmai.com"
    password "password"
    password_confirmation "password"
  end
end
