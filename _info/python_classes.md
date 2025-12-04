# classes

- classes are custom types
- objects are instances of classes
- classes in OOP are about grouping data and behaviour together
- non OOP languages like Go and Rust support encaptulation and abstraction

## inheritance

By adding Aircraft in parentheses after Helicopter, we're saying "make Helicopter a child class of Aircraft". Now Helicopter inherits all the properties and methods of Aircraft!

## class `__init__` constructor

```python

class Aircraft:
    def __init__(self, height, speed):
        self.height = height
        self.speed = speed

    def fly_up(self):
        self.height += self.speed

class Helicopter(Aircraft):
    def __init__(self, height, speed):
        super().__init__(height, speed)
        self.direction = 0

    def rotate(self):
        self.direction += 90

```

The super() method returns a proxy of the parent class, meaning we can use it to call the parent class's constructor and other methods. So the Helicopter's constructor says "first, call the Aircraft constructor, and then additionally set the direction property".

## private methods

```python

class ThisClass:
  def __init__(self, a, b, c):
    self.__a == a # this are now private

o = ThisClass(1,2,3)
print(o.__a) # this will throw an error
```
