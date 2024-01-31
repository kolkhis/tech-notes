
# Project Requirements - requirements.txt

The `requirements.txt` file is used to specify the dependencies of the project.
 
It specifies the packages that are required to run the project, as
well as their versions.

### Generating `requirements.txt`

#### 1. **Using `pip freeze`**:

* If you're using a virtual environment (which is recommended), first activate it.
* Run `pip freeze > requirements.txt`.
* This command lists all installed packages in your 
  environment (including dependencies) and their versions, redirecting
  the output to `requirements.txt`.

```bash
source venv/bin/activate     # On Unix/Linux
venv\Scripts\activate        # On Windows
. venv/Scripts/activate.ps1  # On Windows PowerShell
pip3 freeze > requirements.txt  # Unix/Linux
pip freeze > requirements.txt   # Windows
```

#### 2. **Manually Creating `requirements.txt`**:

* List each package you are directly using in your project, along
  with the desired version, in the `requirements.txt` file.
* This method is more controlled but requires you to manually update
  the file when adding or updating dependencies.
```txt
flask==1.1.2
requests==2.25.1
```


#### 3. **Using `pipreqs`**:
* `pipreqs` is a tool that automatically generates a `requirements.txt` file based on the imports in your Python project.
* Install `pipreqs`: `pip install pipreqs`.
* Run `pipreqs /path/to/project`.
  ```bash
  pipreqs /path/to/your/project/
  ```
*   `pipreqs` is useful because it only lists packages that your project explicitly uses, reducing the risk of including unnecessary dependencies.

#### 4. **Using `poetry` or Similar Tools**:

*   If you are using `poetry` for dependency management, it maintains the dependencies in its own `pyproject.toml` file.
*   You can export the dependencies to a `requirements.txt` file using `poetry export -f requirements.txt --output requirements.txt`.
