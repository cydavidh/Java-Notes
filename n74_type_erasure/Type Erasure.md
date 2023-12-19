https://docs.oracle.com/javase/tutorial/java/generics/erasure.html
# read java docs on type erasure if have time
# Must Cast 
```java
public class List<Type> {
    private Type[] values;

    public List() {
        this.values = new Object[10]; // This will cause a compile-time error
    }
}
```
error: incompatible types: Object[] cannot be converted to Type[]
                this.values = new Object[10];
                                            ^
    where Type is a type-variable:
        Type extends Object declared in class List
1 error

```java
public class List<Type> {
    private Type[] values;

    public List() {
        this.values = (Type[]) new Object[10];
    }
}
```

In Java, when you declare a generic type, like Type in your List<Type> class, the Java compiler replaces Type with its bound or Object if no bound is defined. This process is called type erasure. It's a mechanism that ensures backward compatibility and makes generics more secure.

However, due to type erasure, the runtime system has no way of knowing that Type was ever a part of the List class. As a result, you cannot directly create an array of Type because the runtime system doesn't know what Type is.

So, to get around this limitation, you create an array of Object (since all classes in Java inherit from Object), and then cast it to `Type[]`. This is what `(Type[]) new Object[10]` does.

This is a workaround and it's not type-safe because the Java compiler can't check if your `Object[]` is actually a `Type[]`. But as long as you only put `Type` instances into the array, you won't get a `ClassCastException` at runtime.


# After Type Erasure
```java
public class List<Type> {
    private Type[] values;

    public List() {
        this.values = new Object[10]; // This will cause a compile-time error
    }
}

public class List {
    private Object[] values;

    public List() {
        this.values = new Object[10];
    }
}
```
The generic type Type is replaced with Object, which is the upper bound of all classes in Java. This is because at runtime, due to type erasure, the JVM doesn't know about the generic type Type, so it replaces it with its upper bound, which is Object in this case.
==================================================================
GitHub Copilot: The cast `(Type[])` in the original code is there to tell the compiler that the `Object[]` should be treated as `Type[]`. This is necessary because you can't directly create an array of a generic type in Java.

However, after type erasure, the generic type `Type` is replaced with `Object`, so the cast `(Type[])` is no longer necessary and is removed. The `Object[]` array is directly assigned to `values`.

So, in the original code:

```java
this.values = (Type[]) new Object[10];
```

After type erasure, it becomes:

```java
this.values = new Object[10];
```

Next, you might want to add methods to your `List` class to manipulate the array, like adding, removing, or getting elements.
==========================================================================