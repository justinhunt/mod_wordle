@mod @mod_wordle @core_completion
Feature: View activity completion information in the Wordle resource
  In order to have visibility of wordle completion requirements
  As a student
  I need to be able to view my wordle completion progress

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | student1 | Vinnie    | Student1 | student1@example.com |
      | teacher1 | Darrell   | Teacher1 | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category | enablecompletion | showcompletionconditions |
      | Course 1 | C1        | 0        | 1                | 1                        |
      | Course 2 | C2        | 0        | 1                | 0                        |
    And the following "course enrolments" exist:
      | user | course | role           |
      | student1 | C1 | student        |
      | teacher1 | C1 | editingteacher |

  Scenario: View automatic completion items as teacher
    Given the following "activity" exists:
      | activity       | wordle                     |
      | course         | C1                       |
      | idnumber       | wordle1                    |
      | name           | Music history            |
      | intro          | A lesson learned in life |
      | completion     | 2                        |
      | completionview | 1                        |
    When I am on the "Music history" "wordle activity" wordle logged in as teacher1
    Then "Music history" should have the "View" completion condition

  Scenario: View automatic completion items as student
    Given the following "activity" exists:
      | activity       | wordle                     |
      | course         | C1                       |
      | idnumber       | wordle1                    |
      | name           | Music history            |
      | intro          | A lesson learned in life |
      | completion     | 2                        |
      | completionview | 1                        |
    When I am on the "Music history" "wordle activity" wordle logged in as student1
    Then the "View" completion condition of "Music history" is displayed as "done"

  @javascript
  Scenario: Use manual completion as teacher
    Given the following "activity" exists:
      | activity   | wordle                     |
      | course     | C1                       |
      | idnumber   | wordle1                    |
      | name       | Music history            |
      | intro      | A lesson learned in life |
      | completion | 1                        |
    # Teacher view.
    When I am on the "Music history" "wordle activity" wordle logged in as teacher1
    Then the manual completion button for "Music history" should be disabled

  @javascript
  Scenario: Use manual completion as student
    Given the following "activity" exists:
      | activity   | wordle                     |
      | course     | C1                       |
      | idnumber   | wordle1                    |
      | name       | Music history            |
      | intro      | A lesson learned in life |
      | completion | 1                        |
    # Teacher view.
    When I am on the "Music history" "wordle activity" wordle logged in as student1
    And I toggle the manual completion state of "Music history"
    And the manual completion button of "Music history" is displayed as "Done"

  Scenario: The manual completion button will not be shown on the course wordle if the Show activity completion conditions is set to No as teacher
    Given the following "activity" exists:
      | activity   | wordle                     |
      | course     | C2                       |
      | idnumber   | wordle1                    |
      | name       | Music history            |
      | intro      | A lesson learned in life |
      | completion | 1                        |
    When I am on the "Music history" "wordle activity" wordle logged in as teacher1
    Then the manual completion button for "Music history" should not exist

  Scenario: The manual completion button will not be shown on the course wordle if the Show activity completion conditions is set to No as student
    Given the following "activity" exists:
      | activity   | wordle                     |
      | course     | C2                       |
      | idnumber   | wordle1                    |
      | name       | Music history            |
      | intro      | A lesson learned in life |
      | completion | 1                        |
    When I am on the "Music history" "wordle activity" wordle logged in as student1
    Then the manual completion button for "Music history" should not exist
