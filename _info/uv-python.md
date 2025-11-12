## init project

this will create all the files needed, including pyproject.toml and .venv

`uv python install 3.11.9`
`uv init my_project --python=3.11.9`

or in the same dir

`uv init`

## install python 3.11

`uv python install 3.11`

with constraints

`uv python install ">=3.11,>=3.9`

## update python venv

will update venv to use new version of python

`uv venv --python 3.11`

## add/remove packages

`uv add requests`
`uv remove requests`
