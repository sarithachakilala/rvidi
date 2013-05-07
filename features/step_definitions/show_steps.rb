Given /^a show with the title "([^\"]*)"$/ do |title|
  Show.create!(:title => title, :user_id => 1, :description => "#{title} description")
end

When /^I am on the shows page$/ do
  visit(shows_path)
  page.find("h1#h1_shows_header").should have_content "Listing shows"
end

Then /^I should see "([^\"]*)"$/ do |title|
  page.should have_content title
end

When /^I click on "([^\"]*)"$/ do|title|
  click_link(title)
end

Then /^I should be able to edit "([^\"]*)"$/ do |title|
  click_link("link_edit_#{title.downcase.split(' ').join('_')}")
  fill_in('Title', :with => 'Mark Birthday 35')
  click_on('Update Show')
  page.should have_content 'Mark Birthday 35'
end

Then /^I should be able to delete "([^\"]*)"$/ do |title|
  click_link("link_destroy_#{title.downcase.split(' ').join('_')}")
  page.driver.accept_js_confirms!
  page.should_not have_content(title)
end
