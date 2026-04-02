## init project

- Existing Project (with pyproject.toml)
  If you have an existing pyproject.toml, you simply need to initialize the uv metadata and let it resolve the lockfile.
  Initialize the project:
  Bash
  uv init
  Note: If pyproject.toml exists, it will only add the missing [tool.uv] sections.

* Generate the lockfile and sync:
  Bash
  uv sync
  Evidence: This creates .venv (if missing) and uv.lock, ensuring your environment matches the definition exactly.
  this will create all the files needed, including pyproject.toml and .venv

`uv python install 3.11.9`
`uv init my_project --python=3.11.9`

or in the same dir

`uv init --python=3.11.9`

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
