Feature: analyzing issues
  In order to analyze a ticket
  As a developer
  I want all analyzing tickets to be in a valid state

  Background:
    Given issues with a status of Analyzing
    And none in target version Future

  Scenario: the issue must have an owner
    When i check the assigned_to field
    Then the assigned_to field must be set
