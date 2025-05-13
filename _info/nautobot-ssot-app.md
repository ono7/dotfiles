## install cookie cutter and invoke

`pip install cookiescutter invoke`

## clone repo

```
https://github.com/nautobot/cookiecutter-nautobot-app.git
cd cookiecutter-nautobot-app
invoke bake --template nautobot-app-ssot
```

## run this commands or follow instructions

- poetry lock
- poetry install
- poetry shell
- invoke makemigrations
- invoke ruff --fix # this will ensure all python files are formatted correctly, may require `sudo chown -R $USER ./` as migrations may be owned by root
