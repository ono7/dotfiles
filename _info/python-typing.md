# typing

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
