# Basic Contribution Workflow

This is a straightforward guide to contributing to a project on GitHub.  

---

Prerequisites:

- Set up [SSH authentication](./ssh_for_git.md#ssh-for-github-authentication) for the command line.  

- Have a repository to contribute to.  
    - For the sake of practice, you can create your own repository and use this
      workflow.  
    - If you don't want to create your own repo, the Professional Linux Users Group has a 
      repository specifically for this purpose: 
      <https://github.com/ProfessionalLinuxUsersGroup/GitPracticeRepo>  

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



