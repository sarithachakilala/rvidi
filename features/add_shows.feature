Feature: Add New shows to rVidi

  Scenario: When User tries to Create New Show, when user is not Logged in
    Given I am not Logged in
      And I am in show page of a Show
    When I click on "Start a New Show"
    Then I should be redirected to Login Page

  Scenario: When User tries to Create New Show, when user is Logged in
    Given I am Logged in
      And I am in show page of a Show
    When I click on "Start a New Show"
    Then I should be redirected to New Show Page

  Scenario: When User tries to Save a Show with InVald Details, when user is Logged in
    Given I am Logged in
      And I am in New Show page
    When I fill show form Incompletely
      And I click on "Publish Show"
    Then I should see Show form with errors
    
  Scenario: When User tries to Save a Show with Vald Details, when user is Logged in
    Given I am Logged in
      And I am in New Show page
    When I fill show form Completely
      And I click on "Publish Show"
    Then I should see Show Details Page
