Immutable maps
```java
Map<String, String> emptyMap = Map.of();

Map<String, String> friendPhones = Map.of(
        "Bob", "+1-202-555-0118",
        "James", "+1-202-555-0220",
        "Katy", "+1-202-555-0175"
);
```
1) Collection-like methods:

int size() returns the number of elements in the map;

boolean isEmpty() returns true if the map does not contain elements and false otherwise;

void clear() removes all elements from the map.

2) Keys and values processing:

V put(K key, V value) associates the specified value with the specified key and returns the previously associated value with this key or null;

V get(Object key) returns the value associated with the key, or null otherwise;

V remove(Object key) removes the mapping for a key from the map;

boolean containsKey(Object key) returns true if the map contains the specified key;

boolean containsValue(Object value) returns true if the map contains the specified value.

These methods are similar to the methods of collections, except they process key-value pairs.

3) Advanced methods:

V putIfAbsent(K key, V value) puts a pair if the specified key is not already associated with a value (or is mapped to null) and return null, otherwise, returns the current value;

V getOrDefault(Object key, V defaultValue) returns the value to which the specified key is mapped, or defaultValue if this map contains no mapping for the key.

These methods, together with some others, are often used in real projects.

4) Methods which return other collections:

Set<K> keySet() Returns a Set view of the keys contained in this map;

Collection<V> values() returns a Collection view of the values contained in this map;

Set<Map.Entry<K, V>> entrySet() returns a Set view of the entries (associations) contained in this map.