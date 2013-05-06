# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
    # user_id FactoryGirl.create(:user) # Tp be added once user factory is added
    user_id 1
    title "Mark Birthday Wish"
    description "Every one please add your Birthday wish to mark "
  end
end
