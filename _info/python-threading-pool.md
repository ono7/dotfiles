```python
#!/usr/bin/env python3
"""
multi-threading using pool context manager
profile example in get_time()
"""

import os
import time
from multiprocessing import Pool
from typing import Any, Callable


def expensive_func(n: int) -> int:
    for _ in range(100_100):
        n *= 2
    return n


def single_process(numbers: list[int]) -> list[int]:
    return [expensive_func(n) for n in numbers]


def multi_process(numbers: list[int]) -> list[int]:
    # with calls join() and close()
    with Pool(processes=8) as pool:
        return pool.map(expensive_func, numbers)


def get_time(func: Callable[..., list[int]], *args: Any) -> float:
    # good way to profile how long something takes
    start: float = time.perf_counter()
    func(*args)
    total_time: float = time.perf_counter() - start
    print(f"{func.__name__}: {total_time:.3f} s")
    return total_time


def main() -> None:
    print("CPU count:", os.cpu_count())
    numbers: list[int] = list(range(1, 21))
    assert single_process(numbers) == multi_process(numbers)

    # --- single process benchmark ---
    single_time: float = get_time(single_process, numbers)

    # --- multi process benchmark ---
    multi_time: float = get_time(multi_process, numbers)
    print("single time:", single_time)
    print("multi time:", multi_time)


if __name__ == "__main__":
    main()

# STDOUT:
#   CPU count: 10
#   single_process: 2.584 s
#   multi_process: 0.599 s
#   single time: 2.584128290996887
#   multi time: 0.5985512500046752
```
