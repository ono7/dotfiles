# classes

- classes are custom types
- objects are instances of classes

## private methods

```python

class ThisClass:
  def __init__(self, a, b, c):
    self.__a == a # this are now private

o = ThisClass(1,2,3)
print(o.__a) # this will throw an error
```
