# Interface as an instance variable.

Yes, you can have an instance variable of an interface type in Java. This is a common practice in object-oriented programming and is part of the strategy pattern. 

When you declare a variable as an interface type, you can assign any object to it, as long as the object's class implements the interface. This allows for flexibility because the actual class of the object can be decided at runtime.

Here's an example:

```java
public interface IA {
    void doSomething();
}

public class B implements IA {
    public void doSomething() {
        System.out.println("B is doing something");
    }
}

public class C implements IA {
    public void doSomething() {
        System.out.println("C is doing something");
    }
}

public class D {
    private IA ia;

    public D(IA ia) {
        this.ia = ia;
    }

    public void execute() {
        ia.doSomething();
    }
}
```

In this code, `D` has a private instance variable `ia` of type `IA`. You can create a `D` object with a `B` object or a `C` object, because both `B` and `C` implement `IA`. When you call the `execute` method of the `D` object, it calls the `doSomething` method of the `B` or `C` object.