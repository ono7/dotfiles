# Uninstall current Poetry

sometimes when things get messed up due to a python upgrade, its best to
reinstall poetry, use python3 or python3.11 etc

`curl -sSL https://install.python-poetry.org | python3 - --uninstall`

# Reinstall Poetry

`curl -sSL https://install.python-poetry.org | python3 -`

# install python version

`poetry python install 3.11.11`

# use in a new project

`poetry env use 3.11.11`

```bash
poetry_shell () {
        deactivate 2> /dev/null
        . "$(dirname $(poetry run which python))/activate"
        which python
}
```

activate the new virtual environment

`poetry_shell`

or

`. "$(dirname $(poetry run which python))/activate"`

# sync if there is a pyproject.toml present

`poetry sync`

## using poetry to install new packages

```bash
poetry version minor # will bump minor version for the package i am building
```

```bash
poetry add requests@2.1.23 # add specific version of a package
poetry remove requests # revomes this dependency
poetry add requests^2.12.1 # installs up to the most recent version but not the major could go to 2.31.2 etc
poetry add requests~2.12.1 # installs package up to the latest minor version, 2.12.13
```
