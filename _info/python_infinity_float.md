When you're trying to find a "max" value, it helps to keep track of the "max so far" in a variable and to start that variable at the lowest possible number, negative infinity.

```python
# max_so_far = float("-inf")

def get_most_common_enemy(enemies_dict):
    if not enemies_dict:
        return None
    max_so_far = float("-inf")
    most_enemy = None
    for enemy in enemies_dict:
        if enemies_dict[enemy] > max_so_far:
            max_so_far = enemies_dict[enemy]
            most_enemy = enemy
    return most_enemy
```

You'll also want to keep track of the enemy name associated with the maximum count. I would set the default for that variable to None.
