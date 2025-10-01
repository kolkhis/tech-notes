# PDF Dark Mode Script

These scripts/functions can be run in the browser to convert a PDF into dark 
mode for easier reading.  

```javascript
/*
 *  This function will invert the colors of the current page.
 *  Useful for viewing PDF files in dark mode.
 *  Only tested in Firefox.
 * */

javascript: (function () {
  var el = typeof viewer !== "undefined" ? viewer : document.body;
  el.style.filter = "grayscale(1) invert(1) sepia(1) contrast(75%)";
})();

/* if grayscale(1) and sepia(1) are too harsh
 * - try 'filter:  invert(1) contrast(50%)'
 *   inverts the blacks and whites and adds a contrast of 50% so you get a nice grey backdrop against a white-ish text. */
javascript: (function () {
  var el = typeof viewer !== "undefined" ? viewer : document.body;
  el.style.filter = "invert(1) contrast(50%)";
})();

/*  Clear dark mode by removing the filter.  */
javascript: (function () {
  var el = typeof viewer !== "undefined" ? viewer : document.body;
  el.style.filter = "";
})();
```
