Feature: all issues in the delivered state
  In order to close an issue
  As a developer
  I want all delivered tickets to be clean

  Scenario: an issue should not be owned
    Given issues with a status of Delivered
    When i check the assigned_to field
    Then the assigned_to field must not be set
