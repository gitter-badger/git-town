Feature: git extract: extracting multiple commits (with open changes)

  As a developer working on a feature branch with many commits around an unrelated issue
  I want to be able to extract all of these commits into their own branch
  So that the issue can be reviewed separately and my feature branch remains focussed.


  Background:
    Given I have a feature branch named "feature"
    And the following commits exist in my repository
      | BRANCH  | LOCATION | MESSAGE            | FILE NAME        |
      | main    | remote   | remote main commit | remote_main_file |
      | feature | local    | feature commit     | feature_file     |
      |         |          | refactor1 commit   | refactor1_file   |
      |         |          | refactor2 commit   | refactor2_file   |
    And I am on the "feature" branch
    And I have an uncommitted file
    When I run `git extract refactor` with the last two commit shas


  Scenario: result
    Then it runs the Git commands
      | BRANCH   | COMMAND                                                                     |
      | feature  | git fetch --prune                                                           |
      |          | git stash -u                                                                |
      |          | git checkout main                                                           |
      | main     | git rebase origin/main                                                      |
      |          | git checkout -b refactor main                                               |
      | refactor | git cherry-pick <%= sha 'refactor1 commit' %> <%= sha 'refactor2 commit' %> |
      |          | git push -u origin refactor                                                 |
      |          | git stash pop                                                               |
    And I end up on the "refactor" branch
    And I still have my uncommitted file
    And I have the following commits
      | BRANCH   | LOCATION         | MESSAGE            |
      | main     | local and remote | remote main commit |
      | feature  | local            | feature commit     |
      |          |                  | refactor1 commit   |
      |          |                  | refactor2 commit   |
      | refactor | local and remote | remote main commit |
      |          |                  | refactor1 commit   |
      |          |                  | refactor2 commit   |
    And now I have the following committed files
      | BRANCH   | NAME             |
      | main     | remote_main_file |
      | feature  | feature_file     |
      | feature  | refactor1_file   |
      | feature  | refactor2_file   |
      | refactor | refactor1_file   |
      | refactor | refactor2_file   |
      | refactor | remote_main_file |
