```bash

# ~/.direnvrc
# this is also in ~/.doftfiles/direnv

cd ~/.dotfiles
stow direnv
```

## this goes in ~/.direnvrc

```bash

# vim: ft=bash
layout_poetry() {
  if [[ ! -f pyproject.toml ]]; then
    log_error "No pyproject.toml found. Use $(poetry new) or $(poetry init) to create one first."
    return 1
  fi

  # Get the venv path from poetry
  local VENV=$(
    poetry env info --path 2>/dev/null
    true
  )

  if [[ -z $VENV || ! -d $VENV/bin ]]; then
    log_error "No poetry virtual environment found. Use $(poetry install) to create one first."
    return 1
  fi

  export VIRTUAL_ENV=$VENV
  export POETRY_ACTIVE=1
  PATH_add "$VENV/bin"
}
```

## .envrc

```bash

# .envrc
# this works for uv, or any venv type of environment
if [ -d ".venv" ]; then
  source .venv/bin/activate
fi

# this works with poetry
# this relies on a hook in ~/.direnvc
layout poetry

# if the poetry_layout hook does not work this can go right into the .envrc file
# Check if poetry exists
if command -v poetry &> /dev/null; then
    # Ask poetry for the venv path
    VENV_PATH=$(poetry env info --path 2>/dev/null)

    # If a path was returned and it is a directory, activate it
    if [ -n "$VENV_PATH" ] && [ -d "$VENV_PATH" ]; then
        source "$VENV_PATH/bin/activate"
    fi
fi
```
