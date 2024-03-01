package n08_oop.books;

import java.util.ArrayList;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        // implement here the program that allows the user to enter
        // book information and to examine them

        Scanner scanner = new Scanner(System.in);
        ArrayList<Book> books = new ArrayList<>();
        while (true) {
            System.out.print("Title: ");
            String title = scanner.nextLine();

            if (title.isEmpty()) {
                break;
            }

            System.out.print("Pages: ");
            int pages = Integer.valueOf(scanner.nextLine());

            System.out.print("Publication year: ");
            int year = scanner.nextInt();
            scanner.nextLine();

            // Book book = new Book(title, pages,year);
            // books.add(book);
            books.add(new Book(title, pages, year));
        }

        System.out.print("What information will be printed? (everything, name)");
        String filter = scanner.nextLine();
        if (filter.equals("everything")) {
            for (Book i : books) {
                System.out.println(i);
            }
        } else if (filter.equals("name")) {
            for (Book i : books) {
                System.out.println(i.getTitle());
            }
        }

        scanner.close();
    }
}