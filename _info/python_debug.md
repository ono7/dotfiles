## debug

`pip install remote-pdb`
`brew install socat` -- does not have readline support, must be manually compiled, see `_info/socat_build.md`
`brew install rlwrap`

### use socat to gain readline functionality

socat readline tcp:localhost:4444

or

rlwrap nc localhost 4444

## Run until line 478 (the line immediately after the loop block)

escape loop hell

until 478

## inspect

import inspect

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
