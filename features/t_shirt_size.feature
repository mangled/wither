Feature: t shirt size issues
  In order to retain useful historical information on actuals versus estimates
  As a developer
  I want t shirt sizing to have been performed

  Background:
    Given issues with a status of Unscheduled
    And those with a status of Scheduled
    And those with a status of Develop
    And those with a status of Validate
    And none in target version Future

  @ignore
  Scenario: An issue without a t-shirt size must terminate with a t-shirt sized item
    Given an issue without a t-shirt size
    When i check parents for a t-shirt size
    Then one must have a t-shirt size set

  Scenario: an issue must have an analysis estimate
    Given an issue has a valid t-shirt size
    And the analysis_estimate field must equal the t-shirt size field

  Scenario: an issue must have a valid t-shirt size
    Given an issue has a valid t-shirt size
    When i check the t-shirt size
    Then the t-shirt size must be one of the following:
      |value       |
      |Tiny        |
      |Small       |
      |Medium      |
      |Large       |

  Scenario: an issue with a t-shirt size must not have any children with t-shirt sizes
    Given an issue has a valid t-shirt size
    And i ignore any of its children with the status Discontinued
    When i check it's children
    Then none should have a t-shirt size

  Scenario: an issue without a t-shirt size must have direct children which trace to t-shirt sizes
    Given an issue without a t-shirt size
    And i ignore any of its children with the status New
    And i ignore any of its children with the status Triage
    And i ignore any of its children with the status Backlog
    And i ignore any of its children with the status Wait Analysing
    And i ignore any of its children with the status Analysing
    And i ignore any of its children with the status Discontinued
    When i check each of its children
    Then each should trace to a t-shirt size

