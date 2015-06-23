Feature: Configure woro
  In order to use woro
  As a user
  I want a sane default configuration for my system
  and a data file to store my tasks

  Scenario: Execute woro without configuration
    When I run `woro`
    Then the following files should exist:
      | config/woro.yml   |
    And the output should contain "Initialized default config file in config/woro.yml. See 'woro help init' for options."

  Scenario: Initialize configuration
    When I run `woro init`
    Then the following files should exist:
      | config/woro.yml   |
    And the output should contain "Initialized config file"

  Scenario: Initialize configuration (no clobber)
    Given a file named "config/woro.yml" with:
      """
      hello world
      """
    When I run `woro init`
    Then the output should contain "Not overwriting existing config file"

  Scenario: Force initialize configuration (clobber)
    Given a file named "config/woro.yml" with:
      """
      hello world
      """
    When I run `woro init --force`
    Then the file "config/woro.yml" should not contain "hello world"
