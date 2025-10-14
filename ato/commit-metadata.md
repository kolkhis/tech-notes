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
- Author: the one who wrote the changes
- Committer: actor that applied the changes
- There are common cases for committing someone else's authored commit
    - rebase, cherry-pick, merging a PR for someone
- BUT it can also be a sign of foul play.

Author: the one that does the work/writing
Committer: The person that puts it on the shelf/branch

## Clue #2 - Commit Signing
Best clue you can get.  
- Using a private key you can sign commits.
Gh will examine the authors email and verify commit's signature against the
public key updated to that email account.  

while a private key can be stolen, a commit signature is a pretty strong
signal. 

lack of signature does not necessaily mean the commitis spoofed.

```bash
git commit -S -m "commit msg"
```

The vast majority of people do not sign their commits. Just because it doesn't
have  asignature doesn't mean it's fake, but it does lack authenticity and
question integrity.  

## Clue #3
Final clue: Look at who pushed the commit.  

Pusher: Authenticated Actor that "pushed" the commit to the repo.
- not a git concept, but used for auth

- Terera are common cases for pushing someone else'se commit (rebase,
  cherry-pick, merging pr for someone
- But can be a sign of foul play

## Test

Author and committer being different. Take author name as mickey and committer
as Jessica.  
- A bit suspicious

Author and committer are the same, but someone else pushed.  
- very suspicious.  


When you commit via the web, GitHub will be the committer. (`noreply.github.com`)


- is there a repo config around rejecting unsigned commits?
    - branch protection ruleset

## Recap
- author
- committer
- pusher

Commit identity is a way to get credit for your work. That's super important.  

## Keeping Commit Attribution

Repo hygiene is important. When you squash commits, it makes them into a single
commit, which can hurt attribution.

The **AUTHOR** is the one that gets attribution on the commit.  

Squashing the commit will only let the **author** have credit.  

So how to maintain credit? 

on GitHub, they accept this by using this convention within the actual **commit
message***:
```bash
Co-authored-by: will <will@github.com>
```

---

If you delete a key, all your commits made with that key become unverified.  



## Summary

- Don't believe everything you read on the internet.
    - Use clues to determine confidence of authenticity.  

- Commit metadata
    - author: actor that did the work (deserves credig
    - co-authored-by: give credit by adding a string to msg (non-git concept but accepted convention)
    - committer: actor that applied the work
    - pusher: authenticted actor who pushed upstream (non-git concept)


