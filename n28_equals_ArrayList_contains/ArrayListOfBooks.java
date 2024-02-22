package n28_equals_ArrayList_contains;

import java.util.ArrayList;

public class ArrayListOfBooks {
    public static void main(String[] args) {
        ArrayList<Book> books = new ArrayList<>();
        Book bookObject = new Book("Book Object", 2000, "...");
        books.add(bookObject);

        if (books.contains(bookObject)) {
            System.out.println("Book Object was found.");
        }

        Book bookObject2 = new Book("Book Object", 2000, "...");

        if (books.contains(bookObject2)) {
            System.out.println("A new/different Book Object but with same values was found too.");
        }
    }
}
