@mod @mod_wordle
Feature: Configure wordle appearance
  In order to change the appearance of the wordle resource
  As an admin
  I need to configure the wordle appearance settings

  Background:
    Given the following "courses" exist:
      | shortname | fullname   |
      | C1        | Course 1 |
    And the following "activities" exist:
      | activity | name       | intro      | course | idnumber |
      | wordle     | WordleName1  | WordleDesc1  | C1     | PAGE1    |

  @javascript
  Scenario Outline: Hide and display wordle features
    Given I am on the "WordleName1" "wordle activity editing" wordle logged in as admin
    And I expand all fieldsets
    And I set the field "Display wordle name" to "<value>"
    And I press "Save and display"
    Then I <shouldornot> see "WordleName1" in the "region-main" "region"

    Examples:
      | feature                    | lookfor        | value | shouldornot |
      | Display wordle name          | WordleName1      | 1     | should      |
      | Display wordle name          | WordleName1      | 0     | should not  |
      | Display wordle description   | WordleDesc1      | 1     | should      |
      | Display wordle description   | WordleDesc1      | 0     | should not  |
      | Display last modified date | Last modified: | 1     | should      |
      | Display last modified date | Last modified: | 0     | should not  |
