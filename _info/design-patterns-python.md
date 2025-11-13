# design patterns using python

`https://www.youtube.com/watch?v=gAeZpA6avsA`

## 3 types

1. Creational - how we create objects or components depending on requirements

- builder pattern

2. Structural - how we structure the project and application to achive objectives (architecture)

- testability
- scalability

3. Behavioral - how the components behave in the application and interact with eachother

- based on the structural patterns

### singleton

if 3 components need to talk to an API, a singleton module/function would be created so that they all share that
singleton to communicate with the API instead of having 1 instance per component, creating redundancy code.

a singleton becomes, only one instance, single point of access for a resource (API)

- Disadvangages:
  breaks single responsibility principle, where a particular class would create its own component only when required
  testability issues since the singleton is used by multiple components, this is now tightly coupled to the
  singleton instance and usually cannot be mocked.
  once the singleton is instantiated it creates its own state
