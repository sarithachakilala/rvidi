# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_video do
    user_id 1
    thumbnail_url "MyString"
    download_url "MyString"
    kaltura_entry_id "MyString"
  end
end
