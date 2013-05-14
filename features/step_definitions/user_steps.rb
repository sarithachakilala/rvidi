When(/^i click on "(.*?)"$/) do |arg1|
  visit '/sessions/new'
  click_link 'Join'
end

Then(/^user is able to create his "(.*?)"$/) do |arg1|
  visit '/users/new'
  fill_in 'user_email', :with => 'user@example.com'
  fill_in 'user_username', :with => 'user'
  fill_in 'user_password', :with => 'password'
  fill_in 'user_password_confirmation', :with => 'password'
end
