Feature: new issues
  In order to triage a ticket
  As a developer
  I want all new tickets to be in a valid state

  Background:
    Given issues with a status of New
    And none in target version Future

  Scenario: the source field must be set
    When i check the source field
    Then the source field must be one of the following:
    |value          |
    |Somewhere      |

    Scenario: tickets must be triaged often
      When i check how long a ticket has been waiting
      Then the waiting time should not exceed "3" days
