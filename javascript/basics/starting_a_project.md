
# Starting a New JavaScript Project  

When working with JavaScript projects using npm, you can install dependencies  
locally to your project, similar to how Python virtual environments work.  

Local installation ensures that the dependencies are confined to your project  
and do not affect the global JavaScript environment.  

## Creating a New Project  

A `package.json` file indicates that the current directory is a JavaScript project.  
This file will automatically be generated when you initialize your project.

1. **Initialize Your Project**:  
   * First, create a new directory for your project and initialize it with a `package.json` file. 
   * This file will track your project's dependencies.  
     ```bash  
     mkdir my_project  
     cd my_project  
     npm init -y  
     ```
        * The `npm init -y` command creates a `package.json` file with default values.  

1. **Install Dependencies Locally**:  
    * Install your project's dependencies locally using the `npm install` command.  
      ```bash  
      npm install <package_name>  
      ```
    * This will install the package in your project's `node_modules` directory.  
    * By default, this will install the package only for the current project.  
    * For example, to install Express.js:  
      ```bash  
      npm install express  
      ```


1. Using the Local `node_modules`:  
    * The locally installed packages are accessible for your project's files  
      and can be `require`d or `import`ed as needed.  
    * Node.js will look in your project's `node_modules` directory for these packages.  


### Managing Local Packages  

* `package.json`
    * This file tracks all your local dependencies.  
    * Ensure that it's included in your version control system.  
* `node_modules`
    * This directory contains all the locally installed packages.  
    * It's typically not included in version control (add it to .gitignore).  
* `package-lock.json`
    * Generated after installations and ensures consistent installs across machines.  
    * It should be included in version control.  

---

### Example `package.json` File

After running `npm init` in your project folder, your `package.json` might
look something like this:
```json
{
  "name": "my_project",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}
```

After installing dependencies (`Express.js` in this example), your
`package.json` might look something like this:
```json
{
  "name": "my_project",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.17.1"
  },
  "devDependencies": {},
}
```


### `npm init -y` and `package.json`

The `npm init -y` command is a quick way to initialize a new Node.js project with
a default `package.json` file.

The `-y` flag stands for "yes," and it tells npm to skip the interactive
questionnaire and generate a `package.json` file with default values immediately.

### Breakdown of `npm init -y`

1. **`npm init`**:
   - `npm init` is the standard command used to create a new `package.json` file for a Node.js project.
   - When run without flags, `npm init` prompts the user to answer several questions (like project name, version, description, entry point, etc.) to customize the `package.json` file.

2. **`-y` Flag**:
   - The `-y` flag bypasses these questions and fills in default values automatically.
   - This is useful for quickly setting up a project without the need for customization at the initial stage.

3. **Generated `package.json`**:
   - The `package.json` file created with `npm init -y` will have standard default values:
     - `name`: The name of the directory.
     - `version`: `"1.0.0"`.
     - `description`: An empty string.
     - `main`: `"index.js"`.
     - `scripts`: An object with a test script.
     - `keywords`: An empty array.
     - `author`: An empty string.
     - `license`: `"ISC"`.

### Example

Running `npm init -y` in a directory named `my_project` will create a `package.json` that looks something like this:

```json
{
  "name": "my_project",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}

