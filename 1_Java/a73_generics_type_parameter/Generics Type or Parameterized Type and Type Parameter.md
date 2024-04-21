Basicaly Don't specify type when creating class or interface.

```java
public class Box<T> {}

Box<String> string = new Box<>();
```

`T` is Type Parameter
`Box<T>` is a Generic Type or Parameterized Type (remember, Type is class and class is type)


==========================================================================
```java
public class Locker {//constructor using T, will get compile error because T is not defined}
``` 
// wont work
// Must declare paramter <T> in the class decalration, not just inside. Type parameter is part of class's type

===============================================================================

normal box 
```java
public class Box {
    private Object object;

    public void set(Object object) { this.object = object; }
    public Object get() { return object; }
}
```

generic version of box
```java
/**
 * Generic version of the Box class.
 * @param <T> the type of the value being boxed
 */
public class Box<T> {
    // T stands for "Type"
    private T t;

    public void set(T t) { this.t = t; }
    public T get() { return t; }
}
```

using the box class in main
```java
public class Program {
    public static void main(String[] args) {
        Box<Integer> integerBox = new Box<Integer>();
        //or
        Box<Integer> integerBox = new Box<>();   
    }
}
```



====================================================================
The most commonly used type parameter names are:


E - Element (used extensively by the Java Collections Framework)
K - Key
N - Number
T - Type
V - Value
S,U,V etc. - 2nd, 3rd, 4th types