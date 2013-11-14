# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :cameo_file do
    # ex: association :user, factory: :user, name: "test system02", :op_sub_code => "02"
    association :cameo, factory: :cameo
    file { fixture_file_upload("spec/fixtures/videos/sample.mp4") }
  end

end
