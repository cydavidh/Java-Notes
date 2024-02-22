GitHub Copilot: In Java, you can create a `Comparator` in several ways:

1. **Anonymous Class:** You can create an anonymous class that implements the `Comparator` interface:

```java
Comparator<Card> comparator = new Comparator<Card>() {
    @Override
    public int compare(Card c1, Card c2) {
        return c1.getSuit().ordinal() - c2.getSuit().ordinal();
    }
};
```

2. **Lambda Expression:** If you're using Java 8 or later, you can use a lambda expression to create a `Comparator`:

```java
Comparator<Card> comparator = (c1, c2) -> c1.getSuit().ordinal() - c2.getSuit().ordinal();

Collections.sort(hand, (a, b) -> {
    int suitComparison = Integer.compare(a.getSuit().ordinal(), b.getSuit().ordinal());
    if (suitComparison == 0) {
        return Integer.compare(a.getValue(), b.getValue());
    }
    return suitComparison;
});
```

3. **Comparator.comparing():** If the `Card` class has a method that returns a `Comparable` (like `getSuit()`), you can use the `Comparator.comparing()` method:

```java
Comparator<Card> comparator = Comparator.comparing(c -> c.getSuit().ordinal());
```

4. **Method Reference:** You can also use a method reference to create a `Comparator`:

```java
Comparator<Card> comparator = Comparator.comparing(Card::getSuit);
```

5. **Separate Class:** You can create a separate class that implements the `Comparator` interface:

```java
public class CardComparator implements Comparator<Card> {
    @Override
    public int compare(Card c1, Card c2) {
        return c1.getSuit().ordinal() - c2.getSuit().ordinal();
    }
}
```

And then use it like this:

```java
Comparator<Card> comparator = new CardComparator();
```

Remember, the `compare()` method should return a negative integer if the first argument is less than the second, zero if they're equal, and a positive integer if the first argument is greater than the second.



# Example

.thenComparing()

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