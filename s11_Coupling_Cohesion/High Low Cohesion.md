**Low Cohesion:**

```java
class RobotFactory {
    void createRobots() { /* ... */ }
    void maintainLogistics() { /* ... */ }
    void manageStaff() { /* ... */ }
}
```
=======================================================================================================================================================

**High Cohesion:**
```java
class RobotBuilder { void createRobots() { /* ... */ } }
class Logistics { void maintainLogistics() { /* ... */ } }
class Management { void manageStaff() { /* ... */ } }
```
A class like RobotFactory with multiple unrelated functions is less cohesive. Breaking it into specific classes (RobotBuilder, Logistics, Management) each focusing on one function increases cohesion.

In summary, for better code design, aim for loose coupling (classes don't overly rely on each other's specifics) and high cohesion (classes are focused and specialized).