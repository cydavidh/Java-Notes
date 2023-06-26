package n17_split_string;

import java.util.Scanner;

public class SplitString {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);

        String input = scan.nextLine(); // addition 5
        String[] parts = input.split(" ");

        String command = parts[0]; // addition
        int amount = Integer.valueOf(parts[1]); // 5
    }
}