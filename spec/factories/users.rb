# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :email do |n|
    "rvidi.qwinix.#{n}@yopmai.com"
  end

  sequence :username do |n|
    "rvidi_qwinix_#{n}"
  end


  factory :user do
    first_name "user dummy"
    last_name "Mini Quinix"
    username "rvidi_qwinix"
    email
    password "password"
    password_confirmation "password"
    terms_conditions true
  end
end
