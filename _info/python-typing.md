# typing

## fix annotations that maybe missing

```python

# import the type to use for annotations
from nautobot_ssot.models import Sync

class CustomDataSource(DataSource):
# this does nothing at run time but helps with annotation
# for our IDE
    sync: Sync

    # this = self.sync

    def calculate_diff(self):
        if self.source_adapter is not None and self.target_adapter is not None:
            self.diff = self.source_adapter.diff_to(self.target_adapter, flags=self.diffsync_flags)
            # Remove updates
            update_items = []
            for child in self.diff.get_children():
                if child.action == DiffSyncActions.UPDATE:
                    update_items.append(
                        {
                            "group": child.type,
                            "element": child.name,
                        }
                    )
            for item in update_items:
                self.diff.children[item.get("group")].pop(item.get("element"))
            update_items = None

            self.sync.diff = {}
            self.sync.summary = self.diff.summary()
            self.sync.save()

```

- dependency injection

```python
from typing import Callable

type Data = list[dict[str, any]]

def load_from_csv():
  """load data from csv code"""


class DataPipeline:
  def run(self, loader: Callable[[], Data]) -> None:
    data = loader()


my_data = Datapipeline()
pipeline.run(load_from_csv)
print("pipeline completed")

# use data to annotate function signatures
```
