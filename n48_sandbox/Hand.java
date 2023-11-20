package n48_sandbox;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Hand {
    private List<Card> cards;

    public Hand() {
        this.cards = new ArrayList<>();
    }

    public void add(Card card) {
        this.cards.add(card);
    }

    public void print() {
        this.cards.stream().forEach(card -> {
            System.out.println(card);
        });
    }

    public void printIterator() {
        Iterator<Card> iterator = cards.iterator();

        while (iterator.hasNext()) {
            System.out.println(iterator.next());
            // Card nextInLine = iterator.next();
            // System.out.println(nextInLine);
        }
    }

    public void removeWorst(int value) {
        for (Card card : cards) {
            if (card.getValue() < value) {
                cards.remove(card);
            }
        }
    }

    public void removeWorstIterator(int value) {
        Iterator<Card> iterator = cards.iterator();

        while (iterator.hasNext()) {
            if (iterator.next().getValue() < value) {
                // removing from the list the element returned by the previous next-method call
                iterator.remove();
            }
        }
    }
}