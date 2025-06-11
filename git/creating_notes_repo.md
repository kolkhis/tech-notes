## Create a Notes Repo

Using a Git repository on GitHub is a great way to manage your notes.  
It will also get you hands-on experience with using Git and GitHub.  

I will assume some basic knowledge of Markdown for this guide.  

This is just a "Get Started" with Git, GitHub, and Markdown.  

## Create the repo from scratch

These are just the basic steps to get you started with a notes repository.  

1. Create a directory to put your notes in.  
   ```bash
   mkdir ~/notes
   cd ~/notes
   ```
   
2. Now, initialize a new (local) git repository.  
   ```bash
   git init
   ```

3. Create a README.md file and put some text into it.  
   ```bash
   echo "# My personal notes" > ./README.md
   ```

4. Stage your new file.  
   ```bash
   git add README.md
   ```

5. Now commit your new file.  
   ```bash
   git commit -m "Initial commit"
   ```
   Now the local repo has a commit.  
   But, we don't have a remote repo to push it to.  
   
   Let's create one.  


6. Create a repository on GitHub.  
    - Go to GH -> Top right -> New Repository
    - Give your repo a name ("notes" or "tech-notes"), make sure "Create README.md" is **NOT** checked, and create the repository.  

7. GitHub will give you a list of commands to run. We've already done some of them.  

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


8. Take notes! Your repo is set up and you already have all the tools you need to get
   the job done.  
   For instance, if you need to take notes on Git, maybe create a `git.md`  file and
   add to that.
   ```bash
   touch git.md
   vi git.md
   # make some changes
   git add git.md  # stage
   git commit -m "feat: Add notes on git"
   git push
   ```

That's it. 
