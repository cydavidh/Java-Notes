# So the Comparator object holds a method instead of some value?

Yes, that's correct. The `Comparator` object doesn't hold a value like a typical variable. Instead, it holds a function, specifically a comparison function. This function is used to determine the order of objects.

In your code, `cp` is a `Comparator` object that holds a lambda function `(a, b) -> Double.compare(a, b)`. This function takes two integers `a` and `b` as input and returns the result of `Double.compare(a, b)`, which is a negative integer, zero, or a positive integer depending on whether `a` is less than, equal to, or greater than `b`.

This `Comparator` object can then be used in methods like `List.sort()` or `Stream.sorted()` to sort a collection of integers according to the comparison function.

# So cp is a variable that holds a reference to an instance of a Comparator which holds a function?

Yes, that's correct. The variable cp holds a reference to an instance of Comparator<Integer>. This instance, in turn, holds a function that defines the comparison logic for comparing two integers. This function is used when sorting or ordering collections of integers.

# Comparator examples

```java
Comparator<someClass> cp = (a, b) ->  Double.compare(a.getScore(), b.getScore());

Comparator<someClass> cp = Comparator.comparing(a -> a.getScore());

Comparator<someClass> cp = Comparator.comparing(someClass::getScore);

Comparator<someClass> cp = Comparator.comparingDouble(someClass::getScore);
```

# Why does the comparator sometimes need two variables, such as a and b, to compare and sometimes just one method, such as someClass::getScore

The `Comparator` interface in Java is used to define custom comparison rules for sorting or ordering objects. It has a `compare(T o1, T o2)` method that takes two objects and returns a negative integer, zero, or a positive integer if the first argument is less than, equal to, or greater than the second, respectively.

When you define a `Comparator` using a lambda expression like `(a, b) -> Double.compare(a.getScore(), b.getScore())`, you're providing an implementation for the `compare` method. This implementation takes two objects `a` and `b`, and compares their scores.

On the other hand, `Comparator.comparing(someClass::getScore)` and `Comparator.comparingDouble(someClass::getScore)` are convenience methods provided by the `Comparator` interface. These methods take a function that extracts a key from an object, and return a `Comparator` that compares objects based on these keys.

In `Comparator.comparing(someClass::getScore)`, `someClass::getScore` is a method reference that's equivalent to the lambda expression `a -> a.getScore()`. This function takes one object and returns its score, which is used as the key for comparison.

So, to answer your question, whether you need one or two variables depends on whether you're directly implementing the `compare` method (which requires two variables), or using a convenience method like `Comparator.comparing` (which requires a function to extract a key from one variable).


# Replace lambda 

Sure, you can replace the lambda expression with an anonymous class. Here's how you can do it:

```java
Comparator<SomeClass> cp = new Comparator<SomeClass>() {
    @Override
    public int compare(SomeClass a, SomeClass b) {
        return Double.compare(a.getScore(), b.getScore());
    }
};
```

In this code, we've replaced the lambda expression `(a, b) -> Double.compare(a, b)` with an anonymous class that implements the `Comparator<Integer>` interface. The `compare` method of this anonymous class provides the same comparison logic as the original lambda expression.



# Example

.comparing()
.thenComparing()
Collections.sort(films, comparator);

```java
List<Film> films = new ArrayList<>();
films.add(new Film("A", 2000));
films.add(new Film("B", 1999));
films.add(new Film("C", 2001));
films.add(new Film("D", 2000));

Comparator<Film> comparator = Comparator
              .comparing(Film::getReleaseYear)
              .thenComparing(Film::getName);

Collections.sort(films, comparator);

for (Film e: films) {
    System.out.println(e);
}
```