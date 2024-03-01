package cydavidh.sandbox.s02debugtesting;

public class Util {
    public static void swapInts(int[] ints) {
        int temp = ints[0];
        ints[0] = ints[1];
        ints[1] = temp;
    }
}
