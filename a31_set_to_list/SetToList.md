https://www.geeksforgeeks.org/set-list-java/

```java
    Set<String> set1 = new HashSet<String>();
    set1.add("Geeks");
    set1.add("for");

    List<String> list1 = new ArrayList<String>(set1);
```

The `LinkedList` class in Java has a constructor that accepts a `Collection` type as an argument. Since `ArrayList` implements the `Collection` interface, you can pass an instance of `ArrayList` to the constructor of `LinkedList`.