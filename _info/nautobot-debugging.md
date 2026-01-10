## debugging techniques for nautobot models

`the most important key here is _meta for the model` this holds definitions for every field and relationship to the model

```python
# dt = some model, e.g. DeviceTypes
@(Pdb++) [f.name for f in dt._meta.get_fields()]
```

Why this is best:

```python
# dir(dt) is too noisy (mixes methods and attributes).
# dt.__dict__ only shows locally cached data, missing related objects.
# _meta.get_fields() is the source of truth used by Django itself.
```

## Dump local attributes to the console

this will show what attributes this model takes directly

`pp vars(dt)`

## check attributes

```python
@(Pdb++) dt.manufacturer
<Manufacturer: Ericsson>

# since this is an object, we can also inspect it

@(Pdb++) pp vars(dt.manufacturer)
{'_custom_field_data': {},
 '_state': <django.db.models.base.ModelState object at 0xffff71d8c350>,
 'created': datetime.datetime(2025, 12, 3, 3, 22, 33, 973451, tzinfo=datetime.timezone.utc),
 'description': '',
 'id': UUID('1cfff213-8fc8-4f00-9c7d-4ae96256ab18'),
 'last_updated': datetime.datetime(2026, 1, 7, 14, 32, 24, 19400, tzinfo=datetime.timezone.utc),
 'name': 'Ericsson'}
(Pdb++)

```

## get relationship information

Lists the attribute names you can use (e.g., 'instances', 'interface_templates')

```python
[rel.get_accessor_name() for rel in dt._meta.related_objects]
```

Why it helps: You stop guessing if it's device_set, devices, or instances. You see the exact accessor name
immediately.

## MRO

Nautobot models are heavily composed of Mixins (e.g., OrganizationalModel, PrimaryModel). Checking the Method
Resolution Order (MRO) tells you what features the model supports (Tags, Custom Fields, Notes, etc.).

`dt.__class__.__mro__`

```python
@(Pdb++) pp dt.__class__.__mro__

(<class 'nautobot.dcim.models.devices.DeviceType'>,
 <class 'nautobot.core.models.generics.PrimaryModel'>,
 <class 'nautobot.extras.models.change_logging.ChangeLoggedModel'>,
 <class 'nautobot.extras.models.mixins.ContactMixin'>,
 <class 'nautobot.extras.models.customfields.CustomFieldModel'>,
 <class 'nautobot.extras.models.mixins.DynamicGroupsModelMixin'>,
 <class 'nautobot.extras.models.mixins.DynamicGroupMixin'>,
 <class 'nautobot.extras.models.mixins.NotesMixin'>,
 <class 'nautobot.extras.models.relationships.RelationshipModel'>,
 <class 'nautobot.extras.models.mixins.SavedViewMixin'>,
 <class 'nautobot.core.models.BaseModel'>,
 <class 'django.db.models.base.Model'>,
 <class 'django.db.models.utils.AltersData'>,
 <class 'object'>)

# Check which relationships are currently loaded in memory
@(Pdb++) pp dt._state.fields_cache
{'manufacturer': <Manufacturer: Ericsson>}

```
