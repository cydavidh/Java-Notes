```java
StringBuilder numbers = new StringBuilder();
for (int i = 1; i < 5; i++) {
    numbers.append(i);
}
System.out.println(numbers.toString()); //"1234"
```
StringBuilder is used for efficient string concatenation in Java.

In Java, String objects are immutable, which means once a String object is created, it cannot be changed. When you concatenate strings using the + operator, a new String object is created each time, which can be inefficient in terms of memory and performance, especially in loops.

StringBuilder, on the other hand, is mutable. When you append to a StringBuilder using the append method, it modifies the StringBuilder object itself, rather than creating a new one. This makes it more efficient for concatenating strings in loops or other situations where you need to build a string dynamically.

In your code, StringBuilder is used to build a string of numbers from 1 to 4. This is more efficient than using the + operator to concatenate strings in the loop.