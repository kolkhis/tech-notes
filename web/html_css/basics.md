# HTML/CSS Basics

## Tags v. Elements

A tag in HTML is a single `<..>`.  
An element usually contains two of these tags.
```html
<p>Some text</p>
```
- `<p>`: Tag
- `</p>`: Tag
- `<p>Some text</p>`: Element

An element is the entire thing. It contains the opening and closing tags, as
well as the content.  

## Void Elements

Void elements are elements that don't have content and do not require a 
closing tag.    

- `<hr />`: Horizontal rule
- `<br />`: Break
    - This should be used within paragraphs, not to add linebreaks between
      paragraphs.  
- `<img src="url" />`: Image
- `<meta>`

## Anchor Elements

The anchor element is what is used to create links. 

```html
<a href="https://google.com">Link text</a>
```

Use an anchor to also link to an internal page.
```html
<a href="./about.html">About</a>
```

## Meta Tags

Meta tags specify metadata about the website.  

You can also set a viewport meta tag that dictates how the site should be
displayed, relative to the type of device it's on.  

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```
