Feature: all issues in the done state
  In order to complete an issue
  As a developer
  I want all done tickets to be clean

  Scenario: an issue should not be owned
    Given issues with a status of Done
    When i check the assigned_to field
    Then the assigned_to field must not be set
