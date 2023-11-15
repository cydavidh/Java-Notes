A lambda expression is essentially a shorthand representation of a method. 

```java
(int a, int b) -> a + b;
```

This lambda expression takes two integers as parameters and returns their sum. If we were to convert this into a method in a class, it might look something like this:

```java
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
}
```

In this example, the `add` method in the `Calculator` class does the same thing as the lambda expression. It takes two integers as parameters (`int a, int b`) and returns their sum (`return a + b;`).

The key difference is that the method is named and belongs to a class, while the lambda expression is anonymous and does not belong to any class. However, the behavior of the method and the lambda expression is the same.