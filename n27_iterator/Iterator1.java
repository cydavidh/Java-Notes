package n27_iterator;

import java.util.ArrayList;
import java.util.Iterator;

public class Iterator1 {
    public static void main(String[] args) {

        // creating an ArrayList having default size 10
        ArrayList<Integer> numbers = new ArrayList<Integer>(10);

        // Adding elements to the ArrayList
        numbers.add(12);
        numbers.add(1);
        numbers.add(8);
        numbers.add(5);
        numbers.add(9);
        System.out.println("The list of the size is: " + numbers.size());
        // Showing all the elements in the ArrayList
        for (Integer number : numbers) {
            System.out.println("Number is: " + number);
        }
        // Removing elements greater than 10 using remove() method
        Iterator itr = numbers.iterator();
        while (itr.hasNext()) {
            int data = (Integer) itr.next();
            if (data > 10)
                itr.remove();
        }

        System.out.println("\nAfter removing the element the size of the ArrayList is: " + numbers.size());

        // Showing all the elements in the ArrayList
        for (Integer number : numbers) {
            System.out.println("Number is: " + number);
        }
    }
}
