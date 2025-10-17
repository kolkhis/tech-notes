# Understanding Commit Metadata
## by Staff Engineering Manger at GitHub


## why is it important?
- contains a level of trust
    - would you be more likely to run a script by virus@viruses.com or
      jeschu1@github.com?
- express an author's work
    - My commit titled "ice cream for dinner every day" may not be factual.  

## Commit Metadata
```plaintext
commit 1i2oe23h2f2039f
Author: Jessica Schumaker <jeschu1@github.com>
Dte:  tue Sep 16 20:53:33:33 2025 +0000
```

### Check Commit Metadata
Check the commit metadata. (check profile pic, )

- check name
- check pfp
- check email

compare the 3.  

## Spoofing Commit

Easy to do this by using git config to change username and email and push it up
to be whoever you want.  


```bash
```

### how do you know?
Looking at most commits, you don't know

## Clue #1 - Inspect Metadata

```bash
git log --format=fuller 0c4d01f
```

> Note that `0c4d01f` is a specific commit hash.  

Look at the following fields:

- Author: The one who does the work -- wrote/authored the changes.  
- Committer: The actor that applied the changes -- puts it into the branch itself.  
- There are common cases for committing someone else's authored commit.  
    - E.g., `rebase`, `cherry-pick`, or merging a PR for someone.  
- However, it can also be a sign of foul play if these two are different.  


## Clue #2 - Commit Signing
This is one of the best clues you can get as to whether or not a commit was
spoofed.  

You should use either a GPG or SSH key to sign your commits, this way others
can always verify if the commit was actually done by you.

GitHub will examine the author's email and verify commit's signature against the
public key associated with that email's corresponding GitHub account.  
This will display as a green `verified` badge next to the commit.  

While a private key *can* be stolen, a commit signature is a pretty strong signal of integrity. 

The lack of a signature does not necessaily mean the commit is spoofed, though.
If the author has not set up automatic commit signing, or do not sign their
commits with `-S`, the commit won't be signed.

To manually sign a commit, use `-S` when committing:
```bash
git commit -S -m "commit msg"
```

!!! note "Setting up a Signing Key"

    You will need to go through the process of adding a "Signing Key" to your
    GitHub account for commits to actually be verifiable.  
    I have a writeup on how to get that done using SSH authetication
    [here](/git/ssh_for_git.md)

The vast majority of people do not sign their commits. Just because it doesn't
have a signature doesn't mean it's fake, but it does lack authenticity and
question integrity.  

## Clue #3 - The Pusher
Final clue: Look at who pushed the commit.  

- Pusher: Authenticated Actor that "pushed" the commit to the repo.

    - "Pusher" is not a core Git concept. This is used on GitHub to show who 
      actually pushed the commits up to the repo. This is used on GitHub for authentication.  

- There are common cases for pushing someone else's commit 
    - `rebase`, `cherry-pick`, or merging a PR for someone
- But, if the pusher differs from the author or committer, it could be a sign
  of foul play.  

## Things to Look Out For

- Author and committer are different.  
    - A bit suspicious

- Author and committer are the same, but someone else pushed.  
    - Very suspicious.  

- Unsigned commits
    - A bit suspicious, but plenty of people have not set up commit signing.

!!! note "Committing from GitHub's Web UI"

    When you commit via the web, GitHub will be the committer (`noreply.github.com`).  
    This will also automatically sign the commit (shown as `verified`), since you've
    already authenticated with GitHub using your login credentials.  


There are repo configurations (branch protections/rulesets) that can be set up
to reject unsigned commits.  

If you delete a key that you used to sign commits, all your commits made with 
that key become "unverified". It essentially negates all signatures made with
that key.  

## tl;dr

When checking commits, look for differences in these 3 pieces of metadata:

1. Author
2. Committer
3. Pusher

## Keeping Commit Attribution

Commit identity is a way to get credit for your work. That's super important.  

Repo hygiene is important. When you squash commits, it makes them into a single
commit, which can hurt attribution.

The **AUTHOR** is the one that gets attribution on the commit. **Not the 
committer**.  

Squashing the commit will only let the **author** have credit.  


!!! example "So how do you maintain proper attribution when squashing?"

    On GitHub, using this convention within the actual **commit
    message** will properly attribute the person you specify:
    ```bash
    Co-authored-by: will <will@github.com>
    ```
    This will need to be their name/email used on GitHub to show proper
    attribution on GitHub.  

---


## Pushing as Someone Else

!!! info "Disclaimer"

    This section is only for educational purposes. Do not attempt to
    impersonate other people. That's usually considered fraud.

GitHub will show the profile picture and name as the commit author when the
commit metadata matches their GitHub account.  

All commit metadata comes from your `.gitconfig` file.  
So, if you `.gitconfig` file metadata matches a **different person's** GitHub
data (email, name) then they will show up as the committer on GitHub.  

```bash
git config --global user.name "Some User"
git config --global user.email "someone@example.com"
```

If this metadata (specifically, the `user.email`) matches a GitHub account,
that GitHub accout will be displayed as the user who authored the commit.  

## How Committer and Author are Set

If you create a commit using `git commit`, both the Author and Committer are
set to your name and email from your `.gitconfig` file.  

---

When a maintainer or reviewer applies a patch, merges a pull request, or
submits a change from another contributor, the original creator is the Author,
and the person applying the changes is the Committer.

---

When you rebase (incl. `git pull --rebase`), it rewrites commits to new bases.  
During this process, the Author details (name and date) stay the same, but
the Committer details (name and date) are updated to show who performed the
rebase, and when.  

Cherry-picking a commit takes an existing commit and applies it to another
branch. This updates the Committer information but preserves the Author.  

---

If you amend a commit:
```bash
git commit --amend
```
This preserves the original Author, but the Committer is updated to whoever
made the amendment.  

---

If you apply changes and specify an `--author`:
```bash
git commit --author "A U Thor <author@example.com>"
```
This will record the person running the commit as the Committer, but the Author
will be set to whatever argument is passed to `--author`.  

## Summary

- Don't believe everything you read on the internet.
    - Use clues to determine confidence of authenticity.  

- Commit metadata
    - author: actor that did the work (deserves credig
    - co-authored-by: give credit by adding a string to msg (non-git concept but accepted convention)
    - committer: actor that applied the work
    - pusher: authenticted actor who pushed upstream (non-git concept)


