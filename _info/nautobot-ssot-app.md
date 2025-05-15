## debug

- using `pip install remote-pdb`
  pp inspect.signature(nbdevicetype)

```python
import inspect
pp inspect.getmembers(nbdevicetype)          # Detailed attribute examination
pp inspect.signature(nbdevicetype.save)      # Show function signature

# Basic inspection
pp nbdevicetype
pp dir(nbdevicetype)

# Examine the model specifically
pp nbdevicetype._meta.fields
pp nbdevicetype.model
pp nbdevicetype.manufacturer
pp dir(nbdevicetype.manufacturer)

# See what self.device_type actually is
pp self.device_type
pp inspect.getmro(self.device_type)

# Get a sample of objects
pp list(OrmDeviceType.objects.all())[:2]

```

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
