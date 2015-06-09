# Git Town Branch Hierarchy Architecture

In order to sync and ship branches in the right order and according to their dependencies,
Git Town needs to know information about the [branch hierarchy](../branching_model.md).
This information is stored in the Git configuration for the current repo.

Lets assume a repo has this setup:

```
-o--o-- main
  \
   o--o--o-- feature1
       \
        o-- feature2
```

Git Town stores two types of keys in the Git config. The first key is `git-town.branches.parent`
* `git-town.branches.parent.feature2=feature1`
* `git-town.branches.parent.feature1=master`
It lists which branch the immediate parent branch of the given branch is.

Git Town also caches the full ancestral hierarchy of each feature branch, top-down:
* `git-town.branches.parents.feature2=master,feature1`
* `git-town.branches.parents.feature1=master`
Here we list that in order to sync `feature2`, we need to first sync `master`,
and then `feature1` with `master` as the parent.

