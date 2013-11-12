# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :email do |n|
    "rvidi.qwinix.#{n}@yopmai.com"
  end

  sequence :username do |n|
    "rvidi_qwinix_#{n}"
  end

  sequence :first_name do |n|
    "user dummy #{n}"
  end

  sequence :last_name do |n|
    "last dummy #{n}"
  end


  factory :user do
    first_name
    last_name
    username
    email
    password "password"
    password_confirmation "password"
    terms_conditions true
  end
end
