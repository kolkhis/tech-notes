

# Flexbox



## flex-direction
```css
some_element {
    display: flex;
    flex-direction: row;         /* right, default */
    flex-direction: row-reverse; /* left */
    flex-direction: column;      /* down */
    flex-direction: column-reverse; /* up */
}
```

## justify-content

```css
some_element {
    display: flex;
    justify-content: flex-start; /* default */
    justify-content: flex-end; 
}
```
`flex-end` is always the opposite side of the element's `flex-direction`.

```css
some_element {
    display: flex;
    flex-direction: row;
    justify-content: flex-end; /* justify to the right */
}
```



