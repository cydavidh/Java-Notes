package n09_reading_files_Paths_dot_get;

import java.nio.file.Paths;
import java.util.Scanner;

public class ReadCSV {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(Paths.get("records.txt"))) {

            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();

                String[] parts = line.split(",");
                String name = parts[0];
                int age = Integer.valueOf(parts[1]);

                System.out.println("Name: " + name);
                System.out.println("Age: " + age);
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
