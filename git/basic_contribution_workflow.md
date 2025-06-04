# Basic Contribution Workflow

This is a straightforward guide to contributing to a project on GitHub.  

---

## Prerequisites

- Set up [SSH authentication](./ssh_for_git.md#ssh-for-github-authentication) for the command line.  

- Have a repository to contribute to.  
    - For the sake of practice, you can create your own repository and use this
      workflow.  
    - If you don't want to create your own repo, the Professional Linux Users Group has a 
      repository specifically for this purpose: 
      <https://github.com/ProfessionalLinuxUsersGroup/GitPracticeRepo>  

## Contributing to an Existing Project
These instructions are for creating a feature branch to make a contribution to an
existing repository on GitHub that you do not own yourself.  

### 1. Create a fork of the repository in the Github Web UI.  

   If you're using your own repository, you can skip this step.  

### 2. Clone your fork of the repository.  
   ```bash
   git clone git@github.com:your-username/your-fork.git
   cd ./your-fork
   ```

### 3. Create a new feature branch.  
   ```bash
   git switch -c branch-name
   ```

### 4. Make your edits.  
   ```bash
   vi ./file.md
   # Edit text
   :wq
   ```

### 5. Stage your changes. 
   ```bash
   git add ./file.md
   ```

### 6. Commit your changes.  
   ```bash
   git commit -m "feat: Edited file.md"
   ```

### 7. Push your changes to **your branch** on **your fork**.  
   ```bash
   git push origin branch-name
   ```

### 8. Go to the GitHub web UI (back to your fork) and create a pull request from your fork.  


   A contributor with write access to the original repository will need to approve and
   merge your pull request.  
   
   Once that gets merged, continue on.  
   
   If you're doing this on a repository that you own yourself, you can merge the PR
   yourself by going to your repo -> Pull Requests -> click the PR you opened -> "Merge pull request."  


### 9. Add original repo as a remote source

   ```bash
   git remote add upstream https://github.com/original-place/original-repo.git
   ```

### 10. Pull from the updated original

   ```bash
   git pull upstream main
   ```

   Now your local clone is up to date and you gucci.  

---

## Creating a Notes Repo

Using a repository on GitHub is a great way to manage your notes.  
It also gets you hands-on experience with Git.  


### Create the repo from scratch

1. Create a directory to put your notes in.  
```bash
mkdir ~/notes
cd ~/notes
```

1. Now, initialize a new (local) git repository.  
```bash
git init
```

1. Create a README.md file and put some text into it.  
```bash
echo "# My personal notes" > ./README.md
```

1. Stage your new file.  
```bash
git add README.md
```

1. Now commit your new file.  
```bash
git commit -m "Initial commit"
```
Now the local repo has a commit.  
But, we don't have a remote repo to push it to.  

Let's create one.  


1. Create a repository on GitHub.  
    - Go to GH -> Top right -> New Repository
    - Give your repo a name ("notes" or "tech-notes"), make sure "Create README.md" is **NOT** checked, and create the repository.  

1. GitHub will give you a list of commands to run. We've already done some of them.  

   We want the section that says "Push an existing repository from the command line."  
   ```bash
   git branch -M main
   git remote add origin git@github.com:kolkhis/tech-notes.git
   git push -u origin main
   ```

    - `git branch -M main`: Renames your branch to `main`, instead of the
       default `master` that Git uses.  
       This step is only necessary if you have not configured your default
       branch name to be `main`.  
    - `git remote add origin git@github.com:kolkhis/tech-notes.git`: 
       This adds a new remote repository, called `origin`, pointed to the
       new repo you just created on Github.  
    - `git push -u origin main`: This pushes to `origin/main`, and sets the
      `-u`pstream to this remote and branch.  
        - This basically means that any time you do a `git pull` or `git push`
          without any arguments, it will look here.  


Now, any time that you push or pull:
```bash
git push
git pull
# Defaults to:
git push origin main
git pull origin main
```
It will default to the remote we set as the upstream, the `origin` remote.  











