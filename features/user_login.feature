Feature: Register User
  So that I can enter into the application
  As a new user
  I want to singn up into the application

  Scenario:Register the User into the application
    Given login with the title "Sign Up"
    Then user is able to register with the application
