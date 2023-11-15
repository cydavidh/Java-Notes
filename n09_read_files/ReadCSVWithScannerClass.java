package n09_read_files;

import java.nio.file.Paths;
import java.util.Scanner;

public class ReadCSVWithScannerClass {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(Paths.get("./n09_read_files/presidents.txt"))) {

            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                String[] parts = line.split(";"); // splitting the row into parts on the ";" character

                if (parts.length == 2) { // we want the rows to always contain both the name and the birth year
                    String name = parts[0];
                    int age = Integer.valueOf(parts[1].trim()); // trim() removes whitespace from both ends of a string

                    System.out.println("Name: " + name);
                    System.out.println("Year: " + age);
                }
            }

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
