package cydavidh.sandbox.s02debugtesting;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        int[] ints = new int[2];
        ints[0] = Integer.parseInt(scanner.nextLine());
        ints[1] = Integer.parseInt(scanner.nextLine());

        Util.swapInts(ints);

        System.out.println(ints[0]);
        System.out.println(ints[1]);
    }
}