# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
    # user_id FactoryGirl.create(:user) # Tp be added once user factory is added
    user_id 1
    title "Mark Birthday Wish"
    description "Every one please add your Birthday wish to mark "
    display_preferences "Public"
    display_preferences_password ""
    contributor_preferences "Public"
    contributor_preferences_password ""
    need_review true
  end
end
