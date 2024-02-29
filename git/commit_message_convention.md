

# Git Commit Message Convention


## Table of Contents
* [Git Commit Message Convention](#git-commit-message-convention) 
* [Git Commit Message Structure](#git-commit-message-structure) 
    * [type](#type) 
    * [Description](#description) 
    * [Body](#body) 


## Git Commit Message Structure

The commit message should be structured like this:
```git
[type]: [description]

[body]
```

### type
`[type]`: Indicates the type of the commit. It should be one of the following:

* `feat`: A new feature or functionality added.  
* `fix`: A bug fix or error correction.  
* `docs`: Documentation updates or changes.  
* `style`: Changes to code formatting, indentation, etc.  
* `refactor`: Code refactoring or restructuring without adding new features or fixing bugs.  
* `test`: Adding or updating tests.  
* `chore`: Maintenance tasks or other miscellaneous changes.  

### Description
`[description]`: A brief and concise description of the change made in the commit.

It should start with a capitalized verb and should not exceed 50 characters.


### Body
`[body]` (optional): A more detailed description of the changes made in the commit.

This part is optional but can be useful for providing additional context or 
information about the changes.

