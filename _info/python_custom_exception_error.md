# create and use a custom error message for Exception

```python
class VacationError(Exception):
    def __init__(self, message: str) -> None:
        super().__init__(message)

raise VacationError("this is a test")

```
