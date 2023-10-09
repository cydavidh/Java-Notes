package n06_array_list;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

public class ArrayList1 {

    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>();
        ArrayList<Double> list1 = new ArrayList<>();
        ArrayList<Boolean> list2 = new ArrayList<>();
        ArrayList<String> list3 = new ArrayList<>();

        ArrayList<String> cars = new ArrayList<String>();
        cars.add("Volvo");
        cars.add("BMW");
        cars.add("Ford");
        cars.add("Mazda");
        System.out.println(cars);

        // Arraylist methods
        cars.size(); // 4
        cars.get(0); // Volvo
        cars.set(0, "Toyota"); // Volvo -> Toyota
        cars.remove(0); // returns "Volvo"
        cars.clear(); // Clear full list
        cars.contains("BMW"); // true //boolean found = cars.contains("BMW");

        Collections.sort(cars); // Sort cars
        Collections.max(cars); // Max value

        cars.toString(); // way to print arraylist

        // another way to print arryalist
        for (String i : cars) {
            System.out.println(i);
        }
        for (int i = 0; i < cars.size(); i++) {
            String car = cars.get(i);
            System.out.println(car);
        }

        // initialize arraylist with values
        ArrayList<String> gfg = new ArrayList<String>(Arrays.asList("Geeks", "for", "Geeks"));
        ArrayList<Integer> books = new ArrayList<Integer>(Arrays.asList(0, 1, 2, 3, 4, 5, 6, 7, 8, 10));

    }
}
