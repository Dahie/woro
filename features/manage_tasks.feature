Feature: Manage Woro task
  In order to manage tasks
  As a user
  I want to create, push and list tasks

  Scenario: Execute woro without parameters without environment
    When I run `woro`
    Then the output should contain "Woro environment is not set up. Call `woro init` to do so."

  Scenario: Execute woro without parameters
    Given the Woro environment is set up
    And I run `woro`
    Then the output should contain exactly:
    """
    local ---

    """


  Scenario: List tasks without environment setup
    Given I run `woro list`
    Then the output should contain "Woro environment is not set up. Call `woro init` to do so."

   Scenario: List tasks
    Given the Woro environment is set up
    And a file named "config/woro.yml" with:
      """
      adapters:

      """
    And I run `woro list`
    Then the output should contain exactly:
    """
    local ---

    """

  Scenario: Create local task without environment
    When I run `woro new cleanup`
    Then the output should contain "Woro environment is not set up. Call `woro init` to do so."

  Scenario: Create local task
    Given the Woro environment is set up
    When I run `woro new cleanup`
    And the output should contain "Created lib/woro_tasks/cleanup.rake"

  Scenario: Push local task to remote without environment
    When I run `woro push stub:cleanup`
    Then the output should contain "Woro environment is not set up. Call `woro init` to do so."

  Scenario: Pull local task to remote without environment
    When I run `woro pull stub:cleanup`
    Then the output should contain "Woro environment is not set up. Call `woro init` to do so."
