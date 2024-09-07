package n06_arraylist;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class ArrayList1 {

    public static void main(String[] args) {
        List<String> oldList = List.of("Apple", "Banana", "Cherry");
        ArrayList<String> newList = new ArrayList<String>(oldList);
        ArrayList<Integer> list = new ArrayList<Integer>();
        ArrayList<Double> list1 = new ArrayList<>();
        ArrayList<Boolean> list2 = new ArrayList<>();

        ArrayList<String> cars = new ArrayList<String>();
        cars.add("Volvo");
        cars.add("BMW");
        cars.add("Ford");
        cars.add("Mazda");
        System.out.println(cars);

        // Arraylist methods
        cars.add("Opel");
        cars.add(3, "Opel"); // Add Opel to index 3
        cars.size(); // 4
        cars.get(0); // Volvo
        cars.set(0, "Toyota"); // Volvo -> Toyota
        cars.remove(0); // returns "Volvo"
        cars.remove("Volvo"); // removes first occurence of Volvo, returns true
        cars.clear();
        cars.contains("BMW"); // true
        cars.idexOf("BMW"); // 1

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
