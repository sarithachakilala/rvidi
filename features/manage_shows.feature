Feature: Browse shows
  So that I can browse through the shows
  As a visitor
  I want to be able to see choose a show from a full list of shows and watch it

  Scenario: Browsing a list of shows
    Given a show with the title "Mark Birthday"
      And a show with the title "Dave's Quiz"
    When I am on the shows page
    Then I should see "Mark Birthday"
      And I should see "Dave's Quiz"

  Scenario: Watching a show
    Given a show with the title "Mark Birthday"
    When I am on the shows page
    Then I should see "Mark Birthday"
    When I click on "Mark Birthday"
    Then I should see "Mark Birthday"
      And I should see "Back"

  Scenario: Editing a show
    Given a show with the title "Mark Birthday"
    When I am on the shows page
    Then I should be able to edit "Mark Birthday"

  @javascript
  Scenario: Deleting a show
    Given a show with the title "Mark Birthday"
    When I am on the shows page
    Then I should be able to delete "Mark Birthday"
