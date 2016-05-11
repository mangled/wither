Feature: all issues in the backlog state
  In order to analyze an issue
  As a developer
  I want all tickets to be clean

  @ignore
  Scenario: an issue should have a strategic size
    Given issues with a status of Backlog
    And those with a status of Wait Analysing
    And none in target version Future
    When i check the strategic_estimate field
    Then the strategic_estimate field must have a value greater than zero
