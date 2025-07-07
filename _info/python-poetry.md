# Uninstall current Poetry

sometimes when things get messed up due to a python upgrade, its best to
reinstall poetry, use python3 or python3.11 etc

`curl -sSL https://install.python-poetry.org | python3 - --uninstall`

# Reinstall Poetry

`curl -sSL https://install.python-poetry.org | python3 -`

## using poetry

```bash
poetry version minor # will bump minor version for the package i am building
```

```bash
poetry add requests@2.1.23 # add specific version of a package
poetry remove requests # revomes this dependency
poetry add requests^2.12.1 # installs up to the most recent version but not the major could go to 2.31.2 etc
poetry add requests~2.12.1 # installs package up to the latest minor version, 2.12.13
```
