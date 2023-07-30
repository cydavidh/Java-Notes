package n07_array;

import java.util.Arrays;

public class Array1 {
    public static void main(String[] args) {
        Animal[] zoo = new Animal[4]; //first way to initialize
        zoo[0] = new Tiger();
        zoo[1] = new Giraffe();
        String[] cars = { "Volvo", "BMW", "Ford", "Mazda" }; //another way to initialize
        cars.length; // 4, this is not a method call, so length() wont work

        //Array Methods
        Arrays.sort(cars);
        Arrays.toString(cars); // [BMW, Ford, Mazda, Volvo]
        // array doesn't have method to find element, but lists does:
        Arrays.asList(yourArray).contains(yourObject); //https://stackoverflow.com/questions/3384203/finding-an-element-in-an-array-in-java

        int[][] myNumbers = { { 1, 2, 3, 4 }, { 4, 5, 6 } };
        int x = myNumbers[1][2]; //6
    }
}

// SORTING OBJECTS WITH MULTIPLE PARAMETERS:
// NATURAL SORTING (Created within class)
public class Person implements Comparable<Person> {
    @Override
    public int compareTo(Person o) {
        return Double.compare(this.weight, o2.weight);
    }
    // Use wrapperclass 
    Arrays.sort(listOfPeople);
    Collections.sort(listOfPeople); //will work too
}

// ALTERNATIVE SORTING (Created in sepparate class)
public class SortOnName implements Comparator<Person>{
    @Override
    public int compare(Person o1, Person o2) {
        return o1.getName().compareTo(o2.getName());
    }
    Arrays.sort(listOfPeople, new SortOnName());
}