Feature: Register a User for rVidi Application

  Scenario: Register User Directly for rVidi Application with InValid data
    When I fill Register form Incompletely
      And Click on "Join"
    Then I should not be able to create account
      And should see the form with error messages         

  Scenario: Register User Directly for rVidi Application with Valid data
    When I fill Register form Completely
      And Click on "Join"
    Then I should be able to create account
      And redirected to Home Page of Application

  Scenario: Register/Login User Using Facebook with InValid Credentials
    When I Click on "Login with FaceBook"
    Then I should see the FaceBook Login Page 
    When I fill wrong Facebook Credentials
    Then I should see Errors

  Scenario: Register/Login User Using Facebook with Valid Credentials
    When I Click on "Login with FaceBook"
    Then I should see the FaceBook Login Page
    When I fill Correct Facebook Credentials
    Then I should be logged into the Application
      And I should see User Home Page

  Scenario: Register/Login User Using Twitter with InValid Credentials
    When I Click on "Login with Twitter"
    Then I should see the Twitter Login Page 
    When I fill wrong Twitter Credentials
    Then I should see Errors

  Scenario: Register/Login User Using Twitter with Valid Credentials
    When I Click on "Login with Twitter"
    Then I should see the Twitter Login Page 
    When I fill Correct Twitter Credentials
    Then I should be logged into the Application
      And I should see User Home Page
