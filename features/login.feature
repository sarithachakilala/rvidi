Feature: Register User
  So that I can enter into the application
  As a new user
  I want to singn up into the application

  Scenario: A user successfully signs in with Facebook
    Given I am on the 'homepage'
    When I click "Login with Facebook"
    Then I should see "Logged in Successfully!."