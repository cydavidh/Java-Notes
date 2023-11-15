package n09_read_files;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class ReadFileWithFilesClass {
    public static void main(String[] args) {
        List<String> rows = new ArrayList<>();

        try {
            Files.lines(Paths.get("n09_read_files/file.txt")).forEach(row -> rows.add(row));
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

        // do something with the read lines
    }
}

// Paths.get("n09_read_files/file.txt") // works
// Paths.get("./n09_read_files/file.txt") // works
// Paths.get("/n09_read_files/file.txt") // won't work
