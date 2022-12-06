package n04_repeating_input_break_continue;

import java.util.Scanner;

public class Repeat {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        int numbersRead = 0;
        int sum = 0;

        while (true) {
            System.out.println("Input number");

            int number = Integer.valueOf(scanner.nextLine());

            if (number <= 0) {
                System.out.println("Unfit number! Try again.");
                continue;
                // returns to the start of the loop
            }

            sum = sum + number;
            numbersRead = numbersRead + 1;

            if (numbersRead == 5) {
                break;
                // breaks out of the loop
            }

        }

        System.out.println("The sum of the numbers is " + sum);
    }}

    Scanner reader = new Scanner(System.in);

    // Create variables needed for the loop

    while(true)
    {
    // read input

    // end the loop -- break

    // check for invalid input -- continue

    // handle valid input
}

// functionality to execute after the loop ends