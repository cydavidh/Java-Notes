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
.mapToInt(s -> Integer.valueOf(s))
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