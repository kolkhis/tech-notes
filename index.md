# My Personal Tech Notes
... published into a static site for your convenience.  

---

I write all my notes in Markdown using Vim.  

Due to using markdown, I was able to use `mkdocs` to turn them into a searchable web
page that others can browse and search through.   
I just use `grep` to find what I need, but I published this site **for the people**.

You'll find my most comprehensive notes are probably those on Linux and related 
CLI tools, Bash, monitoring tools, and Perl.  

So here we are! I've accumulated knowledge on various topics and put that knowledge
into words that now exist on the internet.  

Use these words as you see fit. Share them if you want. It's the internet. Do what you want.  

If these notes help you at all, consider giving [the repo](https://github.com/kolkhis/tech-notes/) a star! :)

## Build

This site was built with `mkdocs`. The build process is automated using GitHub
Actions, and the `mkdocs.yml` file (which determines the layout of the website) is 
procedurally generated using a [Bash script](https://github.com/kolkhis/tech-notes/blob/main/scripts/generate-mkdocs-config). I did it this way so that the website would
automatically update each time I add a new file or delete/rename an existing one.  

I originally wrote all these notes in GitHub-flavored Markdown. This was not
fully compliant with MkDocs-flavored Markdown. To address this issue, I wrote a 
[Perl script](https://github.com/kolkhis/tech-notes/tree/main/scripts/mdfix_mkdocs.pl) that
can convert Markdown files to be MkDocs-compliant.  

## Disclaimer

These are my **personal** notes that **I** reference and maintain on a day-to-day basis.  

They are messy.  
Some may be incomplete.  

They are constantly being updated and changed.  





