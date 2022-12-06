package n09_reading_files_Paths_dot_get;

// first
import java.util.Scanner;
import java.nio.file.Paths;

// in the program:

public class Path1 {
    public static void main(String[] args) {
        // we create a scanner for reading the file
        try (Scanner scanner = new Scanner(Paths.get("n09_reading_files_Paths_dot_get/file.txt"))) {

            // we read the file until all lines have been read
            while (scanner.hasNextLine()) {
                // we read one line
                String row = scanner.nextLine();
                // we print the line that we read

                // skip empty line, if the line is blank we do nothing
                if (row.isEmpty()) {
                    continue;
                }

                System.out.println(row);
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
