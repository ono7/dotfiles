Metalearning Plan: C++
> *"Metalearning means learning how to learn the subject. It is the architectural blueprint of your learning project."* — Scott Young, *Ultralearning*
---

Step 1: The "Why" (Goal & Motivation)
Before opening a compiler, pinpoint your exact destination. C++ is massive; learning "all" of C++ is a trap.

1.1 Core Purpose
Check the primary track you are targeting:
[ ] Systems / Embedded: Low-level control, microcontrollers, real-time operating constraints.
[ ] Game Development: Unreal Engine, custom game loops, graphics (OpenGL/Vulkan), physics.
[ ] High-Performance / Quant: Ultra-low latency, memory layout optimization, algorithmic trading.
[ ] Modern General Software: Desktop apps, backend engines, audio/DSP, toolchains.

1.2 Capstone Project
Define the tangible project you will build to prove mastery (avoid passive reading).
Target Project: `[e.g., A lightweight CHIP-8 emulator / A mini physics engine / A multi-threaded HTTP server]`
Success Criteria: `[e.g., Must compile with zero warnings using -Wall -Wextra, run at 60 FPS, handle memory safely via RAII without leaks]`
---

Step 2: The "What" (Deconstruction)
Ultralearning splits knowledge into three buckets: Concepts, Facts, and Procedures.

```sh
                       C++ KNOWLEDGE MAP
  ┌───────────────────────┬──────────────────────┬──────────────────────┐
  │       CONCEPTS        │        FACTS         │      PROCEDURES      │
  │   (Must Understand)   │    (Must Memorize)   │     (Must Practice)  │
  ├───────────────────────┼──────────────────────┼──────────────────────┤
  │ • Stack vs. Heap      │ • Primitive sizes    │ • Writing Make/CMake │
  │ • Pointers/References │ • Keyword meanings   │ • Compiling & linking│
  │ • RAII & Ownership    │   (`const`, `auto`,  │ • Debugging (GDB/LLDB)
  │ • Value Categories    │    `constexpr`)      │ • Memory profiling   │
  │   (lvalue vs. rvalue) │ • Standard library   │   (Valgrind/ASan)    │
  │ • Object Lifetime     │   container names    │ • Writing templates  │
  │ • Virtual Tables      │ • Operator precedence│ • Structuring headers│
  └───────────────────────┴──────────────────────┴──────────────────────┘
```

2.1 Concepts (Deep Mental Models)
Focus on why the language behaves the way it does:
Memory & Address Space: How memory is organized, pointers, pointer arithmetic, addresses.
RAII (Resource Acquisition Is Initialization): Lifecycles, destructors, avoiding manual `new`/`delete`.
Move Semantics & Rvalues: Copying vs. moving resources, `std::move`, perfect forwarding.
The Type System: Static typing, templates, compile-time vs. runtime polymorphism.

2.2 Facts (Quick Retrieval)
C++ standard versions (`C++11`, `C++17`, `C++20` are the core modern baselines).
Common STL container characteristics: `std::vector` (contiguous memory), `std::unordered_map` (hash table), `std::array`.
Smart pointer types: `std::unique_ptr`, `std::shared_ptr`, `std::weak_ptr`.

2.3 Procedures (Hands-on Motor Skills)
Invoking the compiler: `g++ -std=c++20 -Wall -Wextra main.cpp -o app`
Configuring a multi-file build with CMake.
Running AddressSanitizer (`-fsanitize=address`) to catch out-of-bounds reads and leaks.
---

Step 3: The "How" (Strategy & Benchmarking)
Find the best paths, adopt the 10% rule, and avoid classic beginner traps.

3.1 The 10% Rule (Planning Budget)
Spend ~10% of your total estimated project time on research before deep work.
Target Hours: `[e.g., 50 Hours total -> 5 Hours metalearning/setup]`
Deadline: `[e.g., 6 weeks]`

3.2 High-Leverage Curated Resources
Do not learn pre-2011 C++ ("C with Classes"). Focus strictly on Modern C++ (C++17/C++20).
Type  Resource  Purpose
Interactive Tutorial  learncpp.com  Best free, modern, step-by-step curriculum.
Reference cppreference.com  Authoritative dictionary of standard libraries and syntax.
Compiler Playground Compiler Explorer (godbolt.org) Inspect how code turns into assembly in real time.
Core Standards  C++ Core Guidelines (Bjarne Stroustrup & Herb Sutter) Best practices on what idioms to use and avoid.
---

Step 4: Ultralearning Principles in Practice

1. Directness (Learn by Doing)
Never spend more than 30% of a study session reading or watching videos.

70% of time must be spent in an editor writing, breaking, and compiling code.
Tie exercises directly to your capstone project.

2. Drill (Isolating Bottlenecks)
When a concept trips you up, break it out into a standalone test file:
Struggling with pointers? Write a mini linked list from scratch.
Confused by smart pointers? Implement a basic custom `unique_ptr` wrapper.
Confused by templates? Write a generic `clamp()` or `min()` function.

3. Retrieval & Feedback
Test yourself by writing small programs from memory without looking at documentation.
Compile with `-Wall -Wextra -Wpedantic`—treat compiler warnings as mandatory feedback.
Use `clang-tidy` and runtime sanitizers early.
---

Step 5: Weekly Execution Log
Use this tracker to log your sprints:
Week  Focus Area  Hands-On Practice / Drill Hours Status
W1  Tooling, Types, Pointers, Stack/Heap  CLI build setup, basic memory inspector   [ ]
W2  OOP, Structs vs Classes, Lifetimes  Custom dynamic array (`Vector` clone)   [ ]
W3  RAII & Modern Smart Pointers  File I/O manager with zero manual deletes   [ ]
W4  STL Containers & Algorithms Data parser using `std::vector`, `std::ranges`    [ ]
W5  Move Semantics & Templates  Generic buffer class with move constructors   [ ]
W6  Capstone Assembly & Refactoring End-to-end project build + sanitize pass    [ ]
