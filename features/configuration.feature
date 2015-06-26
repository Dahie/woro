Feature: Configure woro
  In order to use woro
  As a user
  I want a sane default configuration for my system
  and a data file to store my tasks

  Scenario: Initialize configuration
    When I run `woro init` interactively
    And I type "n\n"
    And I type "Rails-project\n"
    Then the output should contain "Initialized at `./config/woro.yml`"
    And the following files should exist:
      | config/woro.yml   |

  Scenario: Initialize configuration (no clobber)
    Given a file named "config/woro.yml" with:
      """
      hello world
      """
    When I run `woro init` interactively
    And I type "n\n"
    And I type "Rails-project\n"
    Then the output should contain "Not overwriting existing config file"

  Scenario: Force initialize configuration (clobber)
    Given a file named "config/woro.yml" with:
      """
      hello world
      """
    When I run `woro init --force` interactively
    And I type "n\n"
    And I type "Rails-project\n"
    Then the file "config/woro.yml" should not contain "hello world"
