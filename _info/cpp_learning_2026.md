To transition from Python to Modern C++ in 4 weeks, skip the trivia (bitwise logic, C-style arrays, raw manual allocation) and focus on compilation semantics, references, the modern standard library, and RAII.

Aim for 60–90 minutes a day. Complete every chapter quiz at the CLI with `-Wall -Wextra -Wpedantic` enabled.

---

### Week 1: Build Model & Fundamental Mechanics

_Objective: Understand native compilation, strong static typing, and how modern C++ handles strings._

- **Day 1: Compilation Pipeline & Program Structure**
- **Chapters 1 & 2:** Statements, variable initialization syntax (`int x{5};`), forward declarations, header files (`.h`), and translation units (`.cpp`).
- _Python shift:_ There is no runtime interpreter. Code is parsed, optimized, and linked into machine code before running.

- **Day 2: Data Representation & Type Strictness**
- **Chapter 4:** Fundamental types, object sizing, signed vs. unsigned integer traps, and explicit casts (`static_cast<T>`).

- **Day 3: Constants & Read-Only Memory**
- **Chapter 5 (5.1–5.6):** `const`, compile-time evaluation (`constexpr`), and literal optimization.

- **Day 4–5: Strings vs. String Views**
- **Chapter 5 (5.7–5.9):** `std::string` (owns heap memory) vs. `std::string_view` (non-owning read-only window).
- _Lab:_ Write a CLI program that takes command-line arguments and passes them through functions using `std::string_view` without allocating extra memory.

- **Day 6–7: Operators & Control Flow**
- **Chapters 6 & 8:** Scope resolution, conditional branching, and range-based loops.

---

### Week 2: Memory, Pointers & References (The Crucial Pivot)

_Objective: Demystify memory addresses, reference semantics, and function argument passing._

- **Day 8: Scope, Storage Duration & Linkage**
- **Chapter 7:** Automatic storage duration (stack allocation), block scope, internal vs. external linkage.

- **Day 9–10: Value Categories & References**
- **Chapter 12 (12.1–12.6):** Lvalues vs. Rvalues, lvalue references (`T&`), and const references (`const T&`).
- _Python shift:_ Python variables are transparent object handles; C++ references are explicit compile-time aliases for existing memory addresses.

- **Day 11–12: Pointers & Address-Of Operations**
- **Chapter 12 (12.7–12.14):** Address-of operator (`&`), pointer dereference (`*`), `nullptr`, pointer to `const` vs. `const` pointer, and pass-by-address.

- **Day 13–14: Safe Optionality**
- **Chapter 12 (12.15):** `std::optional`.
- _Lab:_ Write a lookup function that queries a dataset and returns `std::optional<std::string_view>` to signal absent entries cleanly instead of returning null pointers or magic strings.

---

### Week 3: Types, Objects & Classes

_Objective: Build custom data models with deterministic lifetimes._

- **Day 15–16: Aggregates & Structs**
- **Chapter 13:** Scoped enumerations (`enum class`), user-defined structs, and aggregate initialization.

- **Day 17–18: Encapsulation & Member Functions**
- **Chapter 14 (14.1–14.9):** Classes, `public` vs. `private` access specifiers, constructors, and member initialization lists.

- **Day 19–20: Object Lifecycle & RAII**
- **Chapter 14 (14.10–14.17) & Chapter 15:** Destructors, const member functions, and RAII (Resource Acquisition Is Initialization).
- _Python shift:_ Rather than waiting for garbage collection or using `with` context managers, resources release predictably the microsecond the enclosing scope exits.

- **Day 21: Week 3 Capstone Lab**
- Build a basic file-handler class that opens a file on construction and guarantees closing on destruction, verifying it never leaks across errors or early returns.

---

### Week 4: Containers, Smart Pointers & Move Semantics

_Objective: Write modern, leak-free, idiomatic C++ without raw memory management._

- **Day 22–24: Dynamic Arrays & Iterators**
- **Chapter 16 & 17:** `std::vector` mechanics, capacity vs. size, continuous memory layouts, and basic iterators.

- **Day 25–26: Smart Pointers & Ownership**
- **Chapter 22 (22.1–22.6):** `std::unique_ptr` (sole ownership), `std::make_unique`, and `std::shared_ptr`.
- _Golden Rule:_ Never invoke manual `new` or `delete`; let smart pointers manage heap resources.

- **Day 27: Move Semantics & Efficiency**
- **Chapter 22 (22.2–22.4):** R-value references (`&&`), move constructors, and `std::move`. Understand how large buffers transfer ownership rather than deep-copying memory.

- **Day 28: Capstone Project**
- Write a native CLI log-parsing utility:
- Read an input log file using `std::string_view` for parsing tokens.
- Store parsed records in a `std::vector`.
- Track ownership using `std::unique_ptr`.
- Measure performance differences against an equivalent Python script.
