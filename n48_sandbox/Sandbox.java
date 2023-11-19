package n48_sandbox;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class Sandbox {
    public static void main(String[] args) {
        String string = "trolololololo";

        if (string.matches("trolo(lo)*")) {
            System.out.println("Correct form.");
        } else {
            System.out.println("Incorrect form.");
        }
    }
}
