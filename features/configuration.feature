Feature: Configure woro
  In order to use woro
  As a user
  I want a sane default configuration for my system
  and a data file to store my tasks

  # TODO Scenario: Initialize configuration with Rails environment

  Scenario: Initialize configuration without Rails environment
    When I run `woro init` interactively
    And I type "Ftp"
    And I type "localhost"
    And I type "Username"
    And I type "Password"
    And I type "/"
    And I type "n"
    Then the output should contain exactly:
    """
    1. Ftp
    Please choose a service to use with Woro:
    FTP Host: FTP User: FTP Passwod: FTP Folder: Do you want to configure another service?
    Created lib/woro_tasks
    Created lib/tasks
    Created config
    Created `woro.rake` in `lib/tasks`
    Initialized config file in `config/woro.yml`

    """
    And the following directories should exist:
      | lib/woro_tasks      |
      | lib/tasks           |
    And the following files should exist:
      | lib/tasks/woro.rake |

  Scenario: Initialize configuration (no clobber)
    Given a file named "config/woro.yml" with:
      """
      hello world
      """
    When I run `woro init` interactively
    And I type "Ftp"
    And I type "localhost"
    And I type "Username"
    And I type "Password"
    And I type "/"
    And I type "n"
    Then the output should contain "Not overwriting existing config file"

  Scenario: Force initialize configuration (clobber)
    Given a file named "config/woro.yml" with:
      """
      hello world
      """
    When I run `woro init --force` interactively
    And I type "Ftp"
    And I type "localhost"
    And I type "Username"
    And I type "Password"
    And I type "/"
    And I type "n"
    Then the file "config/woro.yml" should not contain "hello world"
