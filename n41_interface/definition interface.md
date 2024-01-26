basically insterface you have constant final field only
and two type of method:
1 non static abstract blueprint method that doesn't do jack shit just outline.
2 static method that does something

```java
interface Interface {
        
    int INT_CONSTANT = 0; 
        
    void instanceMethod1();
                
    static void staticMethod() {
        System.out.println("Interface: static method");
    }
}
```










=============================================================================================================================================

Declaring interfaces
An interface can be considered a special kind of class that can't be instantiated. To declare an interface, you should write the keyword interface instead of class before the name of the interface:

interface Interface { }
An interface can contain:

public constants;

abstract methods without an implementation (the keyword abstract is not required here);

default methods with implementation (the keyword default is required);

static methods with implementation (the keyword static is required);

private methods with implementation.

If the modifiers are not specified once the method is declared, its parameters will be public abstract by default.

The keyword abstract before a method means that the method does not have a body, it just declares a signature. default methods will be discussed in detail in another topic.

An interface can't contain constructors, non-public abstract methods, or any fields other than public static final (constants). Let's declare an interface containing all possible members:

```java
interface Interface {
        
    int INT_CONSTANT = 0; // it's a constant, the same as public static final int INT_CONSTANT = 0
        
    void instanceMethod1();
        
    void instanceMethod2();
        
    static void staticMethod() {
        System.out.println("Interface: static method");
    }
        
    default void defaultMethod() {
        System.out.println("Interface: default method. It can be overridden");
    }

    private void privateMethod() {
        System.out.println("Interface: private methods in interfaces are acceptable but should have a body");
    }
}
```

```java
class Class implements Interface {

    @Override
    public void instanceMethod1() {
        System.out.println("Class: instance method1");
    }

    @Override
    public void instanceMethod2() {
        System.out.println("Class: instance method2");
    }
}
```
=============================================================================================================================================
```java
public interface Readable {
    String read();
}
```

```java
public class TextMessage implements Readable {
    private String sender;
    private String content;

    public TextMessage(String sender, String content) {
        this.sender = sender;
        this.content = content;
    }

    public String getSender() {
        return this.sender;
    }

    public String read() {
        return this.content;
    }
}
```
=============================================================================================================================================

An interface can extend one or more other interfaces using the keyword extends:

```java
interface A { }
interface B { }
interface C { }

interface E extends A, B, C { }
```

Static methods
You can declare and implement a static method in an interface: to use a static method you just need to invoke it directly from an interface:

```java
interface Car {
    static double convertToMilesPerHour(double kmh) {
        return 0.62 * kmh;
    }
}

Car.convertToMilesPerHour(4.5);
```
=============================================================================================================================================



https://docs.oracle.com/javase/tutorial/java/concepts/interface.html
What is interface.