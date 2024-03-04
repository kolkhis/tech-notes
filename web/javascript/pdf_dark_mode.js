/* 
 *  This function will invert the colors of the current page.  
 *  Useful for viewing PDF files in dark mode. 
 *  Only tested in Firefox.  
 * */

javascript: (function () {
  var el = typeof viewer !== "undefined" ? viewer : document.body;
  el.style.filter = "grayscale(1) invert(1) sepia(1) contrast(75%)";
})();

