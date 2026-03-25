"""Sample Python file for treesitter testing."""

from dataclasses import dataclass
from typing import Optional


@dataclass
class User:
    name: str
    age: int
    email: Optional[str] = None

    def greet(self) -> str:
        return f"Hello, {self.name}!"


def fibonacci(n: int) -> list[int]:
    """Generate fibonacci sequence."""
    if n <= 0:
        return []
    sequence = [0, 1]
    for _ in range(2, n):
        sequence.append(sequence[-1] + sequence[-2])
    return sequence[:n]


def main():
    user = User(name="Alice", age=30)
    print(user.greet())

    try:
        numbers = fibonacci(10)
        result = {n: n**2 for n in numbers}
        print(result)
    except ValueError as e:
        print(f"Error: {e}")
    finally:
        print("Done")


if __name__ == "__main__":
    main()
