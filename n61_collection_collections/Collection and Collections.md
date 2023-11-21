Collection: List and Set are interfaces that extends the Collection interface.

Collections is a utility class that consists of methods that operate on or return collections.
For example: Collections.sort()


1. `Collection` is an interface in the Java Collections Framework. It is one of the root interfaces in the collection hierarchy. A `Collection` represents a group of objects known as its elements. The `Collection` interface is used to pass around collections of objects where maximum generality is desired. For example, by convention, all general-purpose collection implementations have a constructor that takes a `Collection` argument.

2. `Collections` is a utility class in java.util package. It consists exclusively of static methods that operate on or return collections. It contains polymorphic algorithms that operate on collections, "wrappers", which return a new collection backed by a specified collection, and a few other odds and ends.

In your code, if you're trying to sort a list, you should import `java.util.Collections;` instead of `java.util.Collection;`.