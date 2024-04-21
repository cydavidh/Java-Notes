```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> evenNumbers = numbers.stream()
                                    .filter(n -> n % 2 == 0)
                                    .collect(Collectors.toList());

System.out.println(evenNumbers); // [2, 4, 6, 8, 10]
```
```java
# Intermediate Operations
.filter(n -> n > 5)
.map(n -> n * 2)
.mapToInt(s -> s.intValue()) // not .mapToInt(s -> Integer.valueOf(s))
.average()
.getAsDouble()
.distinct() // returns a stream consisting of  distinct elements 
.sorted() // returns a sorted stream

# Terminal Operations
.count()
.forEach(n -> System.out.println(n)); // prints 1, 2, 3, 4, 5 on separate lines
.reduce(0, (a, b) -> a + b)
.collect(Collectors.toCollection(ArrayList::new)) // returns ArrayList
.collect(Collectors.toList()) // returns List
```

# reduce(): This method performs a reduction on the elements of the stream with the given function. The result is an Optional describing the reduced value.
```java
.reduce(0, (a, b) -> a + b)
.reduce(*initialState*, (*previous*, *object*) -> *actions on the object*).

List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
Optional<Integer> sum = numbers.stream()
    .reduce((previousSum, value) -> previousSum + value); // sum is an Optional containing 15


ArrayList<String> words = Arrays.asList("First", "Second", "Third");
String combined = words.stream()
    .reduce("", (previousString, word) -> previousString + word + " "); // "First Second Third" 
```

Remember, streams can be used only once. After any terminal operation is called on a stream, it is consumed and can't be used again.






===========================================================================================================================================


```java
List<String> myList = Arrays.asList("apple", "banana", "cherry");
List<String> filteredList = myList.stream()
                                    .filter(s -> s.startsWith("a"))
                                    .collect(Collectors.toList());
```

**In the example provided, myList.stream() returns an object that is an instance of the Stream interface. This is how the Stream interface is related to the example:**

1. Stream Creation: When you call myList.stream(), it creates a stream from the List (myList). The returned stream is an object that implements the Stream interface. This means that the object has all the methods defined in the Stream interface.

2. Using Stream Methods: Once you have a Stream object, you can use any of the methods defined in the Stream interface on it. In the example, two such methods are used:

- filter: This is an intermediate operation provided by the Stream interface, which applies a predicate to each element of the stream and keeps only those elements that satisfy the predicate.
- collect: This is a terminal operation provided by the Stream interface, which transforms the elements of the stream into a different form, in this case, a List.
3. Functional Interface Implementation: The Stream interface methods often take lambda expressions as parameters (like s -> s.startsWith("a") in filter). These lambda expressions are implementations of functional interfaces like Predicate in the case of filter.

4. Relationship to the Stream Interface: Every stream object, including the one returned by myList.stream(), is an instance that conforms to the Stream interface. This means it adheres to the contract defined by the interface: it has all the methods that the Stream interface declares, and it behaves according to the specifications of these methods.

**5. Interface vs. Concrete Implementation: While Stream is an interface, the actual object returned by myList.stream() is an instance of a concrete class that implements the Stream interface. The specifics of this class are abstracted away from the user; you only need to know that it behaves as a Stream.**

In summary, myList.stream() provides a concrete instance of the Stream interface, and the operations performed on this instance (filter, collect) are defined by the Stream interface. This relationship is central to working with streams in Java, allowing for a consistent and powerful way to process sequences of elements.


===========================================================================================================================================
The `Stream` interface in Java includes several static methods that are useful for creating and manipulating streams. Here are some of the key static methods with examples:

1. **`of(T... values)`**:
   - Creates a stream from a sequence of elements.
   - Example: 
     ```java
     Stream<Integer> numberStream = Stream.of(1, 2, 3, 4, 5);
     numberStream.forEach(System.out::println); // Prints 1 to 5
     ```

2. **`concat(Stream<? extends T> a, Stream<? extends T> b)`**:
   - Concatenates two streams into one.
   - Example:
     ```java
     Stream<String> stream1 = Stream.of("A", "B");
     Stream<String> stream2 = Stream.of("C", "D");
     Stream<String> concatenated = Stream.concat(stream1, stream2);
     concatenated.forEach(System.out::println); // Prints A, B, C, D
     ```

3. **`empty()`**:
   - Creates an empty stream.
   - Example:
     ```java
     Stream<String> emptyStream = Stream.empty();
     // Useful when you need a stream that has no elements
     ```

4. **`builder()`**:
   - Provides a builder to build a stream by adding elements one by one.
   - Example:
     ```java
     Stream.Builder<Integer> builder = Stream.builder();
     Stream<Integer> numberStream = builder.add(1).add(2).add(3).build();
     numberStream.forEach(System.out::println); // Prints 1, 2, 3
     ```

5. **`generate(Supplier<T> s)`**:
   - Generates an infinite stream using a `Supplier` function.
   - Example:
     ```java
     Stream<Double> randomNumbers = Stream.generate(Math::random);
     randomNumbers.limit(5).forEach(System.out::println); // Prints 5 random numbers
     ```

6. **`iterate(T seed, UnaryOperator<T> f)`**:
   - Produces an infinite stream by iteratively applying a function to a seed value.
   - Example:
     ```java
     Stream<Long> powersOfTwo = Stream.iterate(1L, x -> x * 2);
     powersOfTwo.limit(5).forEach(System.out::println); // Prints 1, 2, 4, 8, 16
     ```

These static methods provide various ways to create, build, and manipulate streams, making the `Stream` interface a powerful tool for functional-style data processing in Java.