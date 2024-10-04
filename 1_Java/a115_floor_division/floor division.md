Positive numbers (truncation and floor give same result)
```java
7 / 3 = 2
Math.floorDiv(7, 3) = 2
```

Negative numbers (this is where they differ)
```java
-7 / 3 = -2  // Java's truncation division
Math.floorDiv(-7, 3) = -3  // True floor division
```