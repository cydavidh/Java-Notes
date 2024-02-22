**Tight Coupling Example:**
```java
class Engine {
    void run() {
        // Engine running logic
    }
}

class Robot {
    Engine eng = new Engine();

    void activate() {
        eng.run();
    }
}
```
Here, the Robot class directly depends on the Engine class. If you need to change the Engine, you also need to modify Robot. This close dependency makes the code less flexible.
=======================================================================================================================================================
**Loose Coupling Example:**
```java
interface Paint {
    void paint();
}

class Silver implements Paint {
    public void paint() {
        System.out.println("Painted silver");
    }
}

class Gold implements Paint {
    public void paint() {
        System.out.println("Painted gold");
    }
}

class Robot {
    Paint color = new Gold();

    void activate() {
        color.paint();
    }
}
```
In this example, Robot doesn't depend on a specific Paint implementation, allowing you to easily change the paint without altering the Robot class. This demonstrates loose coupling, where Robot knows little about the specifics of Paint implementations.

