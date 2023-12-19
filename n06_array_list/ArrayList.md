# Collection as ArrayList constructor parameter

The `ArrayList` constructor can take a `Collection` as a parameter. 
This will create a new `ArrayList` that is initialized with the elements of the provided `Collection`.

```java
List<String> oldList = Arrays.asList("Apple", "Banana", "Cherry");
ArrayList<String> newList = new ArrayList<>(oldList);
```

# Capacity as constructor parameter

You can also pass an initial capacity (an `int`) to the `ArrayList` constructor. This sets the size of the underlying array that the `ArrayList` uses to store its elements:

```java
ArrayList<String> list = new ArrayList<>(10);
```

In this example, `list` is a new `ArrayList` with an initial capacity of 10. This doesn't mean the `ArrayList` contains 10 elements, but rather that it can hold up to 10 elements before it needs to resize its internal array.

# n35 exact word definition and infer type at tright hand.
# ArrayList<String> list = new ArrayList<String>();

In Java, starting from version 7, the diamond operator `<>` was introduced. This operator allows the compiler to infer the type arguments. This is known as type inference. 

When you create an instance of a generic class like `ArrayList`, you don't need to repeat the type argument on the right-hand side of the statement. The compiler can infer the type from the left-hand side of the statement. 

So, when you write `ArrayList<String> list = new ArrayList<>();`, the compiler understands that you want to create an `ArrayList` of `String` objects.

Here's the pseudocode for this:

```
1. Declare a variable of type ArrayList<String>
2. Instantiate a new ArrayList object using the diamond operator <>
3. The compiler infers the type argument from the left-hand side of the statement
4. Assign the new ArrayList object to the variable
```

And here's the Java code:

```java
ArrayList<String> list = new ArrayList<>();
```

Next, you might want to add some elements to your list, or perhaps remove or access elements.