The removeWorst method doesn't work because it tries to remove an item from a collection while iterating over it using a for-each loop. This is not allowed in Java and will throw a ConcurrentModificationException at runtime.
```java
public void removeWorst(int value) {
    for (Card card : cards) {
        if (card.getValue() < value) {
            cards.remove(card);
        }
    }
}

public void removeWorst(int value) {
    this.cards.stream().forEach(card -> {
        if (card.getValue() < value) {
            cards.remove(card);
        }
    });
}
```

3 ways

# Iterator
```java
public void removeWorstIterator(int value) {
    Iterator<Card> iterator = cards.iterator();

    while (iterator.hasNext()) {
        if (iterator.next().getValue() < value) {
            iterator.remove();
        }
    }
}
```
# Collection.removeIf
```java
public void removeWorst(int value) {
    cards.removeIf(card -> card.getValue() < value);
}
```
# For loop that iterates in reverse order
```java
public void removeWorst(int value) {
    for (int i = cards.size() - 1; i >= 0; i--) {
        if (cards.get(i).getValue() < value) {
            cards.remove(i);
        }
    }
}
```
# ListIterator
```java
public void removeWorst(int value) {
    ListIterator<Card> iterator = cards.listIterator(cards.size());

    while (iterator.hasPrevious()) {
        if (iterator.previous().getValue() < value) {
            iterator.remove();
        }
    }
}
```

