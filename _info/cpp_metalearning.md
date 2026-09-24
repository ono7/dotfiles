# Metalearning Blueprint: C++ (Zero to Builder)

> "Metalearning means learning how to learn the subject. It is the architectural blueprint of your learning project." — Scott Young, _Ultralearning_

---

## 1. Project Scope & Baseline

- **Current Level:** Complete Beginner (Can print "Hello World", learning syntax and console I/O).
- **Core Pitfall to Avoid:** Trying to learn 40 years of legacy C++ all at once. Modern C++ (C++17/20) is safer and cleaner than old tutorials suggest.
- **The 10% Metalearning Rule:** Dedicate 10% of your total study time (e.g., 5-10 hours upfront) to mapping out resources, tools, and drills before deep diving.

### Choose One Capstone Project (Principle of Directness)

Pick **one** mini-project to build toward over the next 4–6 weeks:

- [ ] **Option A: Text-Based Dungeon Crawler** (loops, structs, vectors, combat mechanics)
- [ ] **Option B: Personal Finance / Expense CLI** (file read/write, strings, vectors, sorting)
- [ ] **Option C: Terminal Arcade Game (Snake or Tic-Tac-Toe)** (2D arrays, game loops, user input)

---

## 2. The "What": Deconstructing C++

In _Ultralearning_, you break any skill into **Concepts**, **Facts**, and **Procedures**.

### Concepts (Mental Models — Things You Must Understand)

- **Memory & Variables:** Variables are labeled slots in system memory.
- **Data Types:** C++ is strictly typed. An `int` is not a `string`, and size matters.
- **Control Flow:** How programs make decisions (`if`/`else`) and repeat actions (`for`/`while`).
- **Scope & Lifetime:** Variables created inside `{ }` disappear when the block exits.
- **Pointers & References:** A reference is an alias; a pointer is a variable that stores a memory address.
- **Stack vs. Heap:** Automatic fast memory (Stack) vs. manual dynamic memory (Heap).

### Facts (Rules & Syntax — Things You Must Remember)

- Statements must end with a semicolon `;`.
- The program entry point is always the `main()` function.
- Standard output uses `std::cout <<` and standard input uses `std::cin >>`.
- Arrays and vectors use 0-based indexing (`items[0]` is the first element).
- Modern C++ standard headers do not use `.h` (use `#include <iostream>`, not `#include <iostream.h>`).

### Procedures (Actions — Things You Must Practice Doing)

- Setting up a compiler and building from the terminal or IDE.
- Reading compiler error messages without panicking.
- Using a debugger to set breakpoints and step line-by-line through code.
- Using `std::vector` instead of raw C-style arrays.
- Refactoring repeated code into reusable functions.

---

## 3. The "How": Curated Learning Stack

Stick strictly to these modern resources to avoid outdated C practices:

1. **Primary Course:** [LearnCpp.com](https://www.learncpp.com/) (Free, modern, comprehensive).
   - _Goal:_ Complete Chapters 1 through 11. Complete every quiz at the end of each section.
2. **Quick Testing Tool:** [Compiler Explorer (Godbolt)](https://godbolt.org/)
   - _Goal:_ Test 5–10 line code snippets instantly in your browser without local build overhead.
3. **Reference Manual:** [cppreference.com](https://en.cppreference.com/)
   - _Goal:_ The official dictionary for standard library functions (look up syntax and headers).

---

## 4. Ultralearning Execution Rules

### The 70/30 Practice Rule

- **30% of your time:** Reading explanations and concepts on LearnCpp.com.
- **70% of your time:** Hands-on-keyboard writing, breaking, and fixing code.

### The Retrieval Rule (No Copy-Pasting)

- Never copy-paste code from tutorials. Always type it out line by line.
- **Daily 5-Minute Retrieval Drill:** Before opening notes, open an empty file and write a tiny program from memory (e.g., take two numbers from the user, sum them, and print the output).

### Bottleneck Drills

- When you get stuck on a compiler error, isolate it.
- Create a temporary `test.cpp` file with only 10 lines containing the broken operation until you understand the error.

---

## 5. Six-Week Roadmap (Zero to Working Project)

### Week 1: Basic Input/Output & Variables

- **Topics:** `std::cout`, `std::cin`, `int`, `double`, `std::string`, `if`/`else`.
- **Target Drill:** Build a **Number Guessing Game** (computer picks 1–100, tells you "too high" or "too low").

### Week 2: Loops & Functions

- **Topics:** `while` loops, `for` loops, declaring functions, passing arguments, return values.
- **Target Drill:** Build a **Turn-Based Battle Simulator** (Player and Goblin take turns rolling randomized damage until someone hits 0 HP).

### Week 3: Structured Data & Collections

- **Topics:** `std::vector`, fixed arrays, `struct` for grouping data.
- **Target Drill:** Build an **Inventory System** (add items, view items, display player status).

### Week 4: References & Memory Basics

- **Topics:** Memory addresses, pass-by-value vs. pass-by-reference (`&`), `const` references.
- **Target Drill:** Refactor your inventory and combat functions to pass objects by reference instead of copying them.

### Week 5: Introduction to Classes & OOP

- **Topics:** Classes, `public` vs. `private`, constructors, member functions.
- **Target Drill:** Refactor your character structs into a `Character` class with methods like `takeDamage()` and `isAlive()`.

### Week 6: The Capstone Project

- **Topics:** Multi-file projects (`.h` / `.cpp`), clean code structure, bug fixing.
- **Target Drill:** Complete and polish your chosen Capstone Project from Section 1.

---

## 6. Your Day 1 Action Items

1. **Verify your local toolchain:**
   - Run `g++ --version` or `clang++ --version` in your terminal to confirm your compiler is ready.
2. **Read:**
   - Complete Lessons 1.1 through 1.4 on [LearnCpp.com](https://www.learncpp.com/).
3. **Code Drill 1:**
   - Write a program from scratch that asks for the user's name and age, then prints:
     `"Hello, <name>! You are <age> years old. In 5 years, you will be <age + 5>."`
