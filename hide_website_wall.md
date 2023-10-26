
## Hide a Website's "Disable Adblock" or "Sign Up" Gate

1. Find element that is blocking
2. Set style to `visibility:hidden; z-index:-1000;`
3. Set style of `html` tag to `overflow:scroll;`
    * If necessary, also set this in `body` and `main`

