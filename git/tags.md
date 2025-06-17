# Tags

Tags are references in Git repositories.  
They are used to mark specific points in a repo's history.  

They typically denote the version that a progarm is on, usually following the
semantic versioning standard.  

Tags are immutable references to specific commits.  

## Use Cases

- Marking software versions (e.g., `v2.1.3`)
- Marking release candidates or stable builds
- Creating **release notes** from tag history

Most tags follow [Semantic Versioning (semver)](https://semver.org): `MAJOR.MINOR.PATCH`, e.g., `v.2.1.3`.  

## Types of Tags

There are two types of tags:

1. **Lightweight Tags**
    - Lightweight tags are simple pointers to a commit.  
    - These are simple names pointing directly to a commit (like a bookmark).  
    - These contain no metadata. No tagger info, message, or date.  
    - Stored as a file containing the commit SHA in `.git/refs/tags`

2. **Annotated Tags**
    - Annotated tags include additional metdata (e.g., the tagger's name, email, and a message).  
    - Contains the date and tag message, optionally signed by a GPG key.  
    - Stored as a full git object in `.git/objects/`


## Using `git tag`

The `git tag` command is used to manage the tags for repositories.  

### Adding a Lightweight Tag

To add a tag to a repository, simply use `git tag <tagname>`:
```bash
git tag v1.0.0
```

Verify by running `git tag` with no arguments:
```bash
git tag
# Output:
# v1.0.0
```

This creates a lightweight tag, which is tied to the current commit, and will persist 
until the next tag is set.  

### Adding an Annotated Tag

Use `-a` to specify an annotated tag, and `-m` to specify a message.  
```bash
git tag -a v1.0.0 -m "Initial release of version 1.0.0"
```

Use `-s` for GPG signing (or SSH signing if configured).
```bash
git tag -s v1.0.0 -m "Signed release"
```

### Listing Tags

List tags using `git tag` with no arguments.  
```bash
git tag
```


Filter tags by version by using `-l` and a pattern.  
```bash
git tag -l "v1.*"
```

### View Tag Details

Show metadata and the tagged commit with `git show` and the tag name.   
```bash
git show v1.0.0
```




