Given(/^I am on the Google homepage$/) do
	visit 'https://www.google.co.uk' 
end

Then(/^I will search for "([^"]*)"$/) do |searchText|
	fill_in 'q', :with => searchText
end

Then(/^I should see "([^"]*)"$/) do |expectedText|
	page.should have_content(expectedText)
end


