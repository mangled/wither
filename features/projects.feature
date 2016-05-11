Feature: all issues must be in the correct Redmine project
  In order to manage tickets
  As a developer
  I want all tickets to be in the correct Redmine project

  Background:
    Given all issues

  Scenario: an issue must be in the child sub-project
    When i check the project field
    Then the project field must be set to AProject
