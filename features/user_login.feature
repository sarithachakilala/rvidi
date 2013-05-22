Feature: Registered User should be able to Login to the Applciation

  Scenario: User should see error message when enters InValid Credenatials in Direct Login Form
    When I fill Login Form with InValid Credentials
    Then I should not Logged into the Application and
    I should see Login Form with error Messges

  Scenario: User should be able to Login to the Application when enters Valid Credenatials in Direct Login Form
    When I fill Login Form with Valid Credentials
    Then I should be Logged into the Application and
    I should see User Home Page

  Scenario: User should see error message when enters InValid Credenatials in FaceBook Login Form
    When I Click on "Login with Facebook" and
    When I fill Facebook login form with InValid Credentials
    Then I should not Logged into the Application and
    I should see error Messges

  Scenario: User should be able to Login to the Application when enters Valid Credenatials in FaceBook Login Form
    When I Click on "Login with Facebook" and
    When I fill Facebook login form with Valid Credentials
    Then I should be Logged into the Application and
    I should see User Home Page

  Scenario: User should see error message when enters InValid Credenatials in Twitter Login Form
    When I Click on "Login with Twitter" and
    When I fill Twitter login form with InValid Credentials
    Then I should not Logged into the Application and
    I should see error Messges

  Scenario: User should be able to Login to the Application when enters Valid Credenatials in Twitter Login Form
    When I Click on "Login with Twitter" and
    When I fill Twitter login form with Valid Credentials
    Then I should be Logged into the Application and
    I should see User Home Page
