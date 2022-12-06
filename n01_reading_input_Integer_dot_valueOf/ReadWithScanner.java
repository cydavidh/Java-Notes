package n01_reading_input_Integer.valueOf;

import java.util.Scanner;

public class ReadWithScanner {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String string = scanner.nextLine();
        int integer = Integer.valueOf(scanner.nextLine());
        double floatingPoint = Double.valueOf(scanner.nextLine());
        boolean trueOrFalse = Boolean.valueOf(scanner.nextLine());

        scanner.close();
    }
}
