// Example JavaScript file for treesitter and formatter testing

function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

const users = [
  { name: "Alice", age: 30 },
  { name: "Bob", age: 25 },
  { name: "Charlie", age: 35 },
];

const adults = users.filter((user) => user.age >= 18);

const config = {
  host: "localhost",
  port: 3000,
  debug: true,
};

async function fetchData(url) {
  try {
    const response = await fetch(url);
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Failed to fetch:", error);
    throw error;
  }
}

console.log(fibonacci(10));
console.log(adults);
