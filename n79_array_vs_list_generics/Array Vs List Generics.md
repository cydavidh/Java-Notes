**Review Array**

int[] means Array of integers. int[] arr = {1, 2, 3, 4, 5}; // is [1, 2, 3, 4, 5]
List[] means Array of Lists. Array containing a list at each element.
```java
List<Integer>[] listOfArrays = new List[5];
// add `new ArrayList<>(); to each index``
// add a bunch of numbers to each index like with `new ArrayList<>(Arrays.asList(i, i+1, i+2))``
System.out.println(Arrays.toString(listOfArrays));
// you get [[0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6]]
```
===============================================================================================
**Array vs ArrayList** (cannot create Array of Parameterized Types)

List is a generic type. 
```java
List<T>
Box<T>
Container<T>
LinkedList<T>
```

Array is not. 
```java
int[] integers = new int[33]; //MUST define capacity when initializing
```

=============================================================================================
**Why cannot create Array of Generic Types**

Arrays in Java are covariant and reified, which means they know and enforce their element type at runtime.

But the type parameter is erased at runtime, becomes `Object` (Box<Object>). so how does JVM know the type parameter then? 

(**type perameter of the Generic Type of the Array**)
(eg. Box<T>[], Box is generic type, T is type perameter or parameterized type, [] is array)

So cannot create Arrays of parameterized types.

Unless.

===============================================================================
**Cast Array to solve this problem (cannot create Array of Parameterized Types)**

So we create `new Box[10]` and cast it to `Box<T>[]`

```java
(Box<Integer>[]) new Box[10]
```

However, this will generate an unchecked warning because the runtime type of the array is not `Box<T>[]`, it's `Box[]`.

```java
// Create an array of raw Box type and cast it to Box<Integer>[]
@SuppressWarnings("unchecked")
Box<Integer>[] arrayOfBoxes = (Box<Integer>[]) new Box[10]; 
```

===========================================================================
**Raw type**

A raw type is geeric class without type parameters.

Generic class `Box<T>`

Raw type `Box`

When you use raw type, basically the type parameters are replaced with bound or `Object`.

The Java compiler does not check your use of the raw type, so you can add any type of object to a raw type collection, which defeats the purpose of generics.

```java
Box rawBox = new Box(); // raw type
rawBox.set("Hello"); // This is allowed
rawBox.set(123); // This is also allowed
```

==============================================================================
**ArrayList of Parameterized Types**

ArrayList doesn't have this issue.

Basically ArrayList has a list of objects it adds the type to.

```java
public class ArrayList<T> {
    private Object[] elements;
    private int size;

    public ArrayList() {
        elements = new Object[10]; // Initial capacity
    }

    public void add(T t) {
        // Add the element as an Object
        elements[size] = t;
        size++;
    }

    public T get(int index) {
        // Retrieve the element and cast it to T
        return (T) elements[index];
    }
}
```

And Type checking is done at compile time.

```java
ArrayList<Box<Integer>> listOfBoxes = new ArrayList<>();
listOfBoxes.add(new Box<Integer>()); // This is allowed
listOfBoxes.add(new Box<String>()); // Compile-time error
```

So compiler checks the type, before the interpreter runs the code and do add(T t).

That's how ArrayList prevents adding the wrong type.


===============================================================================================

**Why cannot create Array of Parameterized Types**
**Because 


Please note that you cannot directly create an array of a parameterized type (new List<Integer>[5]), but you can create an array of the raw type (new List[5]) and then put List<Integer> instances into it. This will give a warning about unchecked assignment, because the runtime type of the array is not List<Integer>[], it's List[]. But as long as you only put List<Integer> instances into the array, you won't get a ClassCastException when you get elements out of the array.

GitHub Copilot: The difference between creating a `List` of parameterized types and an array of parameterized types in Java comes down to how generics (used in collections like `List`) and arrays are implemented in the language.

1. **Generics (like `List<T>`):** Generics in Java are a compile-time concept. The type parameter `T` is used to enforce type safety at compile time. Due to a feature called type erasure, the generic type information is removed when the code is compiled, and the compiled bytecode only sees raw types (like `List`, not `List<T>`). This allows generics to maintain backward compatibility with Java versions that do not support generics.

2. **Arrays:** Arrays in Java are covariant and reified. This means they carry their type information with them at runtime. For example, if you create an array of `Integer`, the JVM knows that this array can only contain `Integer` objects.

Because of these differences, you cannot create arrays of parameterized types. If you could, it would create a situation where the Java runtime system cannot correctly enforce the type constraint, leading to potential `ClassCastException`s that would not be caught at compile time.

For example, consider the following code:

```java
public class Box<T> {
    private T t; // T stands for "Type"
    public void set(T t) { this.t = t; }
    public T get() { return t; }
}

// This would not be allowed
Box<Integer>[] arrayOfBoxes = new Box<Integer>[10]; 

// If it were allowed, you could do the following:
Object[] objectArray = arrayOfBoxes; // Box<Integer>[] is a subtype of Object[]
objectArray[0] = new Box<String>(); // This should not be allowed
Integer number = arrayOfBoxes[0].get(); // This would throw a ClassCastException
```

In the above code, we're trying to put a `Box<String>` into an array that should only contain `Box<Integer>`. This would be allowed because at runtime, the JVM only sees a raw `Box` due to type erasure. But when we try to get an element from the box and assign it to an `Integer`, we get a `ClassCastException`.

This is why you cannot create arrays of parameterized types in Java. It's not directly related to type erasure, but rather to the way arrays and generics were designed to work in Java.

Next, you might want to explore other features of generics in Java, or perhaps learn more about the differences between arrays and generics.