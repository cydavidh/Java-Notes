```java
// getting a mutable set from an immutable one
Set<String> countries = new HashSet<>(List.of("India", "Japan", "Switzerland"));

countries.addAll(List.of("India", "Germany", "Algeria"));
System.out.println(countries); // [Japan, Algeria, Switzerland, Germany, India]

countries.retainAll(List.of("Italy", "Japan", "India", "Germany"));
System.out.println(countries); // [Japan, Germany, India]

countries.removeAll(List.of("Japan", "Germany", "USA"));
System.out.println(countries); // [India]
```

addAll: combine old and new set together (union)
retainAll: make set become only elements that is on both old and new list. (intersection)
removeAll: old list, but with new list elements cancelled out. (difference)

containsAll
```java
Set<String> countries = new HashSet<>(List.of("India", "Japan", "Algeria"));

System.out.println(countries.containsAll(Set.of())); // true
System.out.println(countries.containsAll(Set.of("India", "Japan")));   // true
System.out.println(countries.containsAll(Set.of("India", "Germany"))); // false
System.out.println(countries.containsAll(Set.of("Algeria", "India", "Japan"))); // true
```

set equality
```java
Objects.equals(Set.of(1, 2, 3), Set.of(1, 3));    // false
Objects.equals(Set.of(1, 2, 3), Set.of(1, 2, 3)); // true
Objects.equals(Set.of(1, 2, 3), Set.of(1, 3, 2)); // true

Set<Integer> numbers = new HashSet<>();

numbers.add(1);
numbers.add(2);
numbers.add(3);

Objects.equals(numbers, Set.of(1, 2, 3)); // true
```