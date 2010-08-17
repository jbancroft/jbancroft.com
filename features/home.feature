Feature: Home

  So that I can find out more about James Bancroft
  As an internet surfer
  I want to use his website to get information about him

  Scenario: Show the resume
    Given I am on the home page
    When I follow ".resume"
    Then I should be on the resume page
