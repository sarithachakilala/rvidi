# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :title do |n|
    "cameo_#{n}_video"
  end

  sequence :description do |n|
    "cameo_#{n} video description"
  end


  factory :cameo do
    # ex: association :user, factory: :user, name: "test system02", :op_sub_code => "02"
    association :user, factory: :user
    association :show, factory: :show
    director_id 1
    status Cameo::Status::Enabled
    show_id 1
    show_order 1
    title
    description
  end

end
