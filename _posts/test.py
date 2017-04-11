# coprimes.py

from math import gcd
from random import randint

def is_coprime(first, second):
    """Return true if the first and second are coprime i.e. largest
    common factor is 1"""
    return gcd(first, second) == 1

def coprime_probability(limit, times):
    """Estimates the probability of two numbers being coprime via randoms"""
    coprime_count = 0
    for test in range(times):
        a = randint(1, limit)
        b = randint(1, limit)
        if is_coprime(a, b):
            coprime_count += 1
    return coprime_count / times

if __name__ == "__main__":
    print("Probability approximately:", coprime_probability(1000000, 1000000))

