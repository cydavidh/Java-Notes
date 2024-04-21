# **Collection:** List and Set are interfaces that extends the Collection interface. (Map is NOT)

```java
private Map<String, Airplane> airplanes;
private Set<Flight> flights;

public Collection<Airplane> getAirplanes() {
        return this.airplanes.values(); //values() returns a collection of the values
    }

public Collection<Flight> getFlights() {
    return this.flights; //set is a collection so can just return
}
```
In Java, the `Set` interface does extend the `Collection` interface, meaning that a set is a type of collection.

However, the `Map` interface does not extend the `Collection` interface. A map is not considered a collection in the strictest sense according to the Java Collections Framework, even though it is part of it. This is because a map stores key-value pairs, not just values like the other collection types. 

So, while you can iterate over a map or a set similarly to other collections, there are also unique operations you can perform on them due to their specific characteristics. For example, with a map, you can look up a value directly using its key.



# **Collections** is a utility class that consists of methods that operate on or return collections.
For example: Collections.sort()

