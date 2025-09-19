# Repo Files for GitHub 

Certain files can go into a `.github/` directory inside a repository to affect how
GitHub works with the repo.  

<https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file>

## Code Owners
* `CODEOWNERS`: Specify specific files for users. Users will be automatically added
  as reviewers for any changes to these files.  
    - [GitHub Docs on CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
    * When a PR changes a file listed in `CODEOWNERS`, the specified users are automatically added as reviewers.
    * Useful for enforcing code reviews and ensuring domain experts review changes.
    * Format for `CODEOWNERS`:
      ```plaintext
      # Format: <file path> <GitHub username or team>
      # Assign @alice and @bob to review all changes
      * @alice @bob
  
      # Assign @frontend-devs team to review changes in the frontend directory
      /frontend/ @frontend-devs
  
      # Assign @backend-lead to review all .go files in the backend directory
      /backend/*.go @backend-lead
  
      # Assign @security to review security-related files
      SECURITY.md @security
      ```
  
## Templates


* `ISSUE_TEMPLATE/` (directory): Add custom issue templates in markdown for how to format issues.  
    - e.g., `ISSUE_TEMPLATE/bug_report.md`
* `PULL_REQUEST_TEMPLATE.md`: Add a custom PR template in markdown for how to format pull requests.  

More about [issue templates here](./issue-templates.md).  


## Contributions

- `CONTRIBUTING.md`: Contains guidelines for contributing to the project.  

- `FUNDING.yml`: Add sponsorship buttons for the current repository.  
    - Example format:
      ```yaml
      github: ['your-github-username']
      patreon: 'your-patreon-username'
      open_collective: 'your-open-collective-slug'
      ```


## GitHub Actions
- `.github/workflows/` (directory): A collection of yaml files for GitHub Actions workflows.  
    - E.g., `deploy.yml` example:
      ```yaml
      name: Deploy
      on: push
      jobs:
        deploy:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
            - run: echo "Deploying"
      ```


## tl;dr:
| File | Purpose |
|------|---------|
| `CODEOWNERS` | Assign reviewers for PRs |
| `README.md` | Repository description |
| `LICENSE` | Define repository licensing |
| `.gitignore` | Ignore files from Git tracking |
| `CONTRIBUTING.md` | Contribution guidelines |
| `SECURITY.md` | Security policies |
| `ISSUE_TEMPLATE/` | Custom issue templates |
| `PULL_REQUEST_TEMPLATE.md` | Guide PR submissions |
| `FUNDING.yml` | Enable sponsorships |
| `CODE_OF_CONDUCT.md` | Community behavior rules |
| `GOVERNANCE.md` | Open-source governance rules |
| `.github/workflows/` | GitHub Actions for automation |

