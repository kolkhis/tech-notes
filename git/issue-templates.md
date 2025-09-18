# GitHub Issue Templates/Forms

GitHub offers an "Issue Template" feature.  

Issue templates are pre-filled forms that are shown when a user clicks "New Issue."  
They attempt to ensure every new issue has all the key details needed
(reproduction steps, page URLs, screenshots, etc.).  

They can automatically label, assign, and give a title to issues so that
maintainers can address them quickly.  

You can disable blank issues so that people must use the templates.  

Issue templates can either work at the **repo level**, or at the
**organization** level (via a `.github` repository).  

These templates can either be in Markdown (now considered legacy), or in YAML.  
The YAML variant is called an **Issue Form** instead of a template. These are
better for structured fields and validation.  

## Where to Add Templates

Repo-specific templates go in the `.github/ISSUE_TEMPLATES/` directory in the 
root of the repository.  

## Issue Template Config

Issue templates need a configuration file that lets the user choose which
template to use.  
The "chooser" config file lives in `.github/ISSUE_TEMPLATES/config.yml`.  

A basic `config.yml` would look something like this:
```yaml
blank_issues_enabled: false

contact_links:
  - name: Contribution Guide
    url: https://website.com/contributing
    about: Please read before opening issues or PRs.  

  - name: Questions/Support (Discussions)
    url: https://github.com/<org>/<repo>/discussions
    about: For how-to questions, use Discussions instead of issues.  

# Optional:
# Add default labels that are added to every issue if no template is chosen
default_labels: ["question"]
```

- `blank_issues_enabled`: Defines whether or not using an issue template is
  **required**.  
    - If `false`, people **must** pick one of the templates. 
    - If `true`, people are **not required** pick one of the templates. 
- Each of the `contact_links` appear in the issue chooser as buttons.  


## Resources

- [Issue Template Docs](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository)
    - [Creating Issue Forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository#creating-issue-forms)
    - [Configuring the Template Chooser](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository#configuring-the-template-chooser)
    - [Syntax for Issue Forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms)


