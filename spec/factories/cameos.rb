# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cameo do
    # ex: association :user, factory: :user, name: "test system02", :op_sub_code => "02" 
    association :user, factory: :user
    director_id 1
    status "approved"
    show_id 1
    show_order 1
    name "Cameo1 Video"
    description "Cameo1 Video Desc"
    tags "tag1"
    thumbnail_url "http://cdnbakmi.kaltura.com/p/1409052/sp/140905200/thumbnail/entry_id/0_w22rt37j/version/100000"
    download_url "http://cdnbakmi.kaltura.com/p/1409052/sp/140905200/raw/entry_id/0_w22rt37j/version/0"
    duration "15"
    kaltura_entry_id "1_g42tyf6u"
  end
end
