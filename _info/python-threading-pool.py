#!/usr/bin/env python3
"""multithreading using pool example"""

from multiprocessing import Pool
from typing import Any, Callable


def expensive_func(n: int) -> int:
    for _ in range(100_100):
        n *= 2
    return n


def single_process(numbers: list[int]) -> list[int]:
    return [expensive_func(n) for n in numbers]


def multi_proccess(numbers: list[int]) -> list[int]:
    # with calls join() and close()
    with Pool() as pool:
        return pool.map(expensive_func, numbers)


def get_time(func: Callable[..., list[int]], *args: Any) -> float: ...
