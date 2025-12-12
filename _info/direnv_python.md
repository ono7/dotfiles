```bash

# .envrc
# this works for uv, or any venv type of environment
if [ -d ".venv" ]; then
  source .venv/bin/activate
fi

# this works with poetry
layout poetry

# or the nuclear option
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
