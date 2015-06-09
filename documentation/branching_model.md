# Git Town Branching Model

Git Town has a more opinionated branching model than vanilla Git.
It treats branches as a strict hierarchy.
Let's look at this example:

```
-o--o-- main
  \
   o--o--o-- feature1
       \
        o-- feature2
```

The main branch is the shared root branch for all branches.
Off the main branch we cut the `feature1` branch, and added a few commits to it
Off the `feature1` branch, we cut the `feature2` branch.
To Git Town, `feature2` is a child branch of `feature1`.
It cannot be shipped or synced
without shipping/synching `feature1` first.
As a matter of fact, Git Town automatically syncs `feature1` before syncing
`feature2`, and shows an error message when trying to ship `feature2` before
`feature1`.

Since this branching model exceeds the much more generic branching model
of Git, Git Town maintains its own copy of information which branch depends on which
other branch.
Occasionally it asks the user who the parent branch of a certain feature
branch is.
