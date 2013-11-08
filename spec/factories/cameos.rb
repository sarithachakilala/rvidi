# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :cameo do
    # ex: association :user, factory: :user, name: "test system02", :op_sub_code => "02"
    association :user, factory: :user
    director_id 1
    status Cameo::Status::Enabled
    show_id 1
    show_order 1
    name "Cameo1 Video"
    description "Cameo1 Video Desc"
  end

end
