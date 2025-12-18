## how to create a nautobot ssot and job

`https://networktocode.com/blog/building-a-nautobot-ssot-app/`

## django

## select related to save on db quieres when looking up foreign keys

https://www.youtube.com/watch?v=mO-pfdJpnBA

`Device.objects.all().select_related('interfaces')` you can inspect the Device model to
figure out what foreign keys are available and minimize the number of queries

this create a inner join which is much faster than individual queries

## access nautobot inside a container using cookiecutter template

`invoke nbshell`

- this is the fastest way to delete objects `Device.objects.all().delete()`

* Query data

```python
Software.objects.filter(ratings__gte=5)
Software.objects.first() # is the same as LIMIT 1 in sql
Software.objects.all() # gets all the objects
Software.objects.all()[0] # gets first object
Software.objects.exclude(ratings=5) # will bring everything except 5
Software.objects.exclude(ratings__lte=5) # will bring everything except <= 5

# the __gte is a lookup that django uses internally which will translate to >= in
# the database
```

- Update data

```python

sw = Software.object.first() # get the first object on the table
sw.name = "test"
sw.save() # this method will update the record with the name "test"
```

- validators

```python
from django.core.validators import MinValueValidator .....

```

### Order of operations when loading adapters

```python
self.load_tenants()        # 1. Foundation - needed by VRFs and other resources
self.load_vrfs()           # 2. Network contexts - needed by prefixes/IPs
self.load_devicetypes()    # 3. Device metadata - needed before devices
self.load_deviceroles()    # 4. Device metadata - needed before devices
self.load_devices()        # 5. Physical devices - needed before interfaces
self.load_interfaces()     # 6. Device interfaces - needed before IP assignments
self.load_prefixes()       # 7. Network prefixes - should exist before IPs
self.load_ipaddresses()    # 8. IP addresses - depend on prefixes and interfaces
```

## debug

`pip install remote-pdb`
`brew install socat`
`brew install rlwrap`

### use socat to gain readline functionality

socat readline tcp:localhost:4444

or

rlwrap nc localhost 4444

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
