GitHub Copilot: A `HashMap` in Java retrieves keys quickly due to its use of the hashing principle. When you put a key-value pair into the `HashMap`, it uses the `hashCode()` method of the key object to calculate a hashcode. This hashcode is then used to calculate an index in the underlying array where the value is stored.

When you later retrieve the value using the `get()` method and the same key, `HashMap` again uses the `hashCode()` method to calculate the same hashcode, and hence the same array index. This allows it to directly access the location of the value in the array, making retrieval fast.

This is a simplified explanation. In reality, there can be collisions where different keys have the same hashcode and hence map to the same array index. `HashMap` handles this by storing multiple key-value pairs at the same index in a linked list or a tree (for larger lists), and then it uses the `equals()` method to find the correct key-value pair within that list or tree.

Here's a basic example:

```java
HashMap<String, Integer> map = new HashMap<>();
map.put("One", 1); // "One".hashCode() is used to determine the storage location
Integer value = map.get("One"); // "One".hashCode() is used to find the value quickly
```

In this example, the `hashCode()` of the string "One" is used to quickly store and retrieve the associated value.