Feature: Google for raveparty

Scenario: Search for the website        
	Given I am on the Google homepage
	Then I will search for "RaveParty"
	Then I should see "party pills"
