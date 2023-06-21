package n01_scanner_data_types_valueof_test_input;

import java.util.Scanner;

public class ReadWithScanner {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String string = scanner.nextLine();
        int integer = Integer.valueOf(scanner.nextLine());
        double floatingPoint = Double.valueOf(scanner.nextLine());
        boolean trueOrFalse = Boolean.valueOf(scanner.nextLine());

        String input = "one\n" + "two\n" +
                "three\n" + "four\n" +
                "five\n" + "one\n" +
                "six\n";

        Scanner reader = new Scanner(input);
        String line = reader.nextLine();
        System.out.println(line);
        String line2 = reader.nextLine();
        System.out.println(line2);
    }
}
