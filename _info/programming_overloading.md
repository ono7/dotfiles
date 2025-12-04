```python


1 + 2  # 3

# strings overload the "+" operator

"hi" + "there"  # "hithere"

# lists can overload the "+" operator

[1,2] + [3,4]  # [1,2,3,4]

# classes can overload it "+" with `__add__(self, v2)`

self.v1 + v2  # Vector addition

```

- Fix (mental model)
  When you hear “overload,” think:
  “This operator now handles more types than it originally did.”

  One operator → many meanings → “overloading.”
