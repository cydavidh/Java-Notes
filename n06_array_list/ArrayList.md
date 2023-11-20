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