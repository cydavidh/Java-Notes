package n91_varargs;

public class VarargsExample {

    // Method with varargs
    public static void printNumbers(int... numbers) {
        for (int number : numbers) {
            System.out.println(number);
        }
    }
    public static void main(String[] args) {
        printNumbers(1, 2, 3, 4, 5); // Call with multiple arguments
        printNumbers(10); // Call with one argument
        printNumbers(new int[19]); // you can invoke the method by passing several integer numbers or an array of ints.
        printNumbers(new int[] {}); // no arguments here
        printNumbers(new int[] {1, 2});
    }
}
