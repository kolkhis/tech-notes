
# Miscellaneous Python Notes

## Python HTTP Server

You can use `python3 -m http.server` to serve a directory.


## MkDocs Static Website

Requirements for `mkdocs`:
* mkdocs
* mkdocs-awesome-pages-plugin
* mkdocs-material
* mkdocs-git-revision-date-localized-plugin
* markdown-emdash
* git-revision-date-localized
* python-markdown
* mdx_emdash


```bash
mkdocs serve -a 0.0.0.0:3000
```
Produces a static site

## Containerize the application
To safely share with others, you need to containerize the application.

