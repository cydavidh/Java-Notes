Sure, an Iterator is an interface in Java that provides methods to iterate over any Collection. It is a way of fetching items from a collection one by one.

Here's a simple example of using an Iterator with a List:

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>(Arrays.asList("Apple", "Banana", "Cherry"));

        Iterator<String> iterator = list.iterator();
        while (iterator.hasNext()) {
            String fruit = iterator.next(); //careful not to use iterator.next() to compare otherwise it jumps
            System.out.println(fruit);
        }
    }
}
```

In this example, we first create a List of Strings. We then get an Iterator from the list using the `iterator()` method. The `hasNext()` method of the Iterator is used to check if there are more elements in the list. If there are, we get the next element using the `next()` method.

When you run this code, it will print:

```
Apple
Banana
Cherry
```

This shows that the Iterator has gone through each element in the list.