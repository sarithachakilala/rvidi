Given(/^I am not Logged in$/) do
  # visit home_index_path
  # click_on 'Log Out'
  @current_user = nil  
end

Given(/^I am Logged in$/) do
  @user = User.where(:email => "pnagalla@qwinixtech.com").first || FactoryGirl.create(:user)
  visit sign_in_path
  fill_in 'login', with: "pnagalla@qwinixtech.com"
  fill_in 'password', with: "password"
  click_on 'Log in'
  @current_user = @user
  visit dashboard_user_path(@user)
  # page.should have_content('Logout')
end

# Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|  
#   visit login_url  
#   fill_in "Username", :with => username  
#   fill_in "Password", :with => password  
#   click_button "Log in"  
# end  

Given(/^I am in New Show page$/) do
  visit new_show_path
end

When(/^I fill show form Incompletely$/) do
  fill_in 'login', with: "pnagalla@qwinixtech.com"
  
end

When(/^I click on "(.*?)"$/) do |arg1|
  pending
end

Then(/^I should see Show form with errors$/) do
  pending
end

Given(/^I am in show page of a Show$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be redirected to Login Page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be redirected to New Show Page$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I fill show form Completely$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see Show Details Page$/) do
  pending # express the regexp above with the code you wish you had
end


# ======================
# Given /^a show with the title "([^\"]*)"$/ do |title|
#   Show.create!(:title => title, :user_id => 1, :description => "#{title} description")
# end

# When /^I am on the shows page$/ do
#   visit(shows_path)
#   page.find("h1#h1_shows_header").should have_content "Listing shows"
# end

# Then /^I should see "([^\"]*)"$/ do |title|
#   page.should have_content title
# end

# When /^I click on "([^\"]*)"$/ do|title|
#   click_link(title)
# end

# Then /^I should be able to edit "([^\"]*)"$/ do |title|
#   click_link("link_edit_#{title.downcase.split(' ').join('_')}")
#   fill_in('Title', :with => 'Mark Birthday 35')
#   click_on('Update Show')
#   page.should have_content 'Mark Birthday 35'
# end

# Then /^I should be able to delete "([^\"]*)"$/ do |title|
#   click_link("link_destroy_#{title.downcase.split(' ').join('_')}")
#   page.driver.accept_js_confirms!
#   page.should_not have_content(title)
# end
# ======================
