package n09_read_files;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ReadCsvWithFilesClass {
    public static void main(String[] args) {
        List<Person> presidents = new ArrayList<>();
        try {
            presidents = Files.lines(Paths.get("./n09_read_files/presidents.txt"))
                    .map(row -> row.split("; ")) // note the space after the semicolon
                    .filter(parts -> parts.length == 2) // filter parts with 2 parts
                    .map(parts -> new Person(parts[0], Integer.valueOf(parts[1]))) // create persons from parts
                    .collect(Collectors.toCollection(ArrayList<Person>::new));
            // .forEach(person -> presidents.add(person)); // add persons to the list

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage()); // print the error message
        }

        presidents.stream()
                .forEach(person -> System.out.println(person.toString()));
    }
}
