Feature: validate issues
  In order to validate tickets
  As a developer
  I want all tickets to be in the correct state for validation

  Background:
    Given issues with a status of Validate
    And none in target version Future

  Scenario: the issue must have an owner
    When i check the assigned_to field
    Then the assigned_to field must be set
