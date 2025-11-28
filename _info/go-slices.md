# slices (passed by reference)

different ways to access a slice

```go
numbers := []int{1, 2, 3, 4, 5}

// Slice from index 1 to 3 (exclusive)
fmt.Println(numbers[1:3])  // Prints: [2 3]

// Slice from beginning to index 3 (exclusive)
fmt.Println(numbers[:3])   // Prints: [1 2 3]

// Slice from index 2 to end
fmt.Println(numbers[2:])   // Prints: [3 4 5]

// Full slice
fmt.Println(numbers[:])    // Prints: [1 2 3 4 5]
```

```go
numbers := []int{1, 2, 3, 4, 5}
fmt.Println("Length:", len(numbers))  // Prints: Length: 5

// Print last element
fmt.Println("Last element:", numbers[len(numbers)-1])  // Prints: Last element: 5

// append numbers to slice
numbers := []int{1, 2, 3}
numbers = append(numbers, 4, 5)
fmt.Println(numbers)  // Prints: [1 2 3 4 5]
```
