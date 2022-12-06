package n06_array_list;

import java.util.ArrayList;
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
        cars.remove(0); // Toyota removed
        cars.clear(); // Clear full list
        cars.contains("BMW"); // true //boolean found = cars.contains("BMW");

        Collections.sort(cars); // Sort cars

        for (String i : cars) {
            System.out.println(i);
        }
        for (int i = 0; i < cars.size(); i++) {
            String car = cars.get(i);
            System.out.println(car);
        }

    }
}
