## install cookie cutter and invoke

`pip install cookiescutter invoke`

## clone repo

```
git clone https://github.com/nautobot/cookiecutter-nautobot-app.git
cd cookiecutter-nautobot-app

invoke bake --template nautobot-app-ssot

# edit any files or dependencies to pyproject.toml

poetry lock && poetry install && poetry_shell && invoke makemigrations
```
