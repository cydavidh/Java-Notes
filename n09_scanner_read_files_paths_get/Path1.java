package n09_scanner_read_files_paths_get

// first
import java.util.Scanner;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

// in the program:

public class Path1 {
    public static void main(String[] args) {
        // we create a scanner for reading the file
        try (Scanner scanner = new Scanner(Paths.get("./n09_reading_files_Paths_dot_get/file.txt"))) {

            // try (Scanner fileReader = new Scanner(new
            // File("/n09_reading_files_Paths_dot_get/file.txt"))) {

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

        // when can't find the file even if you put in same folder
        // https://jenkov.com/tutorials/java-nio/path.html
        // first see the current directory
        Path currentDir = Paths.get("."); // output is C:\Java-DSA-Notes\.
        System.out.println(currentDir.toAbsolutePath());
        // from here we just change the path
        // e.g.
        // "src/main/java/recipe.txt"
        // "/n09_reading_files_Paths_dot_get/recipe.txt"
    }
}
