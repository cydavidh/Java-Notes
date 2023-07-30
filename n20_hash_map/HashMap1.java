package n20_hash_map;

import java.util.HashMap;

import n08_oop.books.Book;

public class HashMap1 {
    public static void main(String[] args) {
        HashMap<String, String> postalCodes = new HashMap<>();
        postalCodes.put("00710", "Helsinki");
        postalCodes.put("90014", "Oulu");
        postalCodes.put("33720", "Tampere");
        postalCodes.put("33014", "Tampere");

        System.out.println(postalCodes.get("00710")); // Helsinki
        System.out.println(postalCodes.get("33720")); // Tampere
        System.out.println(postalCodes.get("33014")); // Tampere

        HashMap<String, Book> directory = new HashMap<>();
        Book senseAndSensibility = new Book("Sense and Sensibility", 1811, "...");
        directory.put("Sense and Sensibility", senseAndSensibility);
        Book prideAndPrejudice = new Book("Pride and Prejudice", 1813, "....");
        directory.put("Pride and Prejudice", prideAndPrejudice);
    }
}
