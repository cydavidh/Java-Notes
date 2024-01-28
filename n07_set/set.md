HashSet, TreeSet, and LinkedHashSet.

Set<String> people = Set.of("Larry", "Kenny", "Sabrina");

order doesn't matter
no duplicates

System.out.println(emptySet.contains("hello")); // false
===========================================================================================================================================

HashSet elements stored by hashcode.
Set<String> countries = new HashSet<>();
countries.add("India");
===========================================================================================================================================
TreeSet order matters.
sorted either by their natural order (if they implement the Comparable interface) or by specific Comparator implementation.

`Comparator<? super E> comparator()` returns the comparator used to order elements in the set or null if the set uses the natural ordering of its elements;

`SortedSet<E> headSet(E toElement)` returns a subset containing elements that are strictly less than toElement;

`SortedSet<E> tailSet(E fromElement)` returns a subset containing elements that are greater than or equal to fromElement;

`SortedSet<E> subSet(E fromElement, E toElement) `returns a subset containing elements in the range fromElement (inclusive) toElement (exclusive);

`E first()` returns the first (lowest) element in the set;

`E last()` returns the last (highest) element in the set.

The following example demonstrates some of the listed methods:

SortedSet<Integer> sortedSet = new TreeSet<>();

```java 
sortedSet.add(10);
sortedSet.add(15);
sortedSet.add(13);
sortedSet.add(21);
sortedSet.add(17);

System.out.println(sortedSet); // [10, 13, 15, 17, 21]

System.out.println(sortedSet.headSet(15)); // [10, 13]
System.out.println(sortedSet.tailSet(15)); // [15, 17, 21]
 
System.out.println(sortedSet.subSet(13,17)); // [13, 15] 

System.out.println(sortedSet.first()); // minimum is 10
System.out.println(sortedSet.last());  // maximum is 21
```

===========================================================================================================================================
LinkedHashSet as fast as hashset but also has order, combination of above two.
```java
Set<Character> characters = new LinkedHashSet<>();

for (char c = 'a'; c <= 'k'; c++) {
    characters.add(c);
}
        
System.out.println(characters); // [a, b, c, d, e, f, g, h, i, j, k]
```