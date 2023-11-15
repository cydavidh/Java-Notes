package n48_sandbox;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Sandbox {
    public static void main(String[] args) {
        List<String> rows = new ArrayList<>();

        try {
            Files.lines(Paths.get("file.txt")).forEach(row -> rows.add(row));
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

    }
}
