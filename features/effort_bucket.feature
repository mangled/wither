Feature: all issues relate to an effort bucket
  In order to track effort in general areas
  As a developer
  I want all tickets to trace to an effort bucket

  Scenario: an issue should trace back to an effort bucket
    Given issues with a status of Backlog
    And none in target version Future
    And those with a status of Wait Analysing
    And those with a status of Analysing
    And those with a status of Unscheduled
    And those with a status of Scheduled
    And those with a status of Develop
    And those with a status of Validate
    And none in target version Future
    When i check an issues eldest parent
    Then it should be an effort bucket
