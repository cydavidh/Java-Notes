package n47_stream;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

public class Stream {
    public static void main(String[] args) {
        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        List<Integer> evenNumbers = list.stream()
                .filter(n -> n % 2 == 0)
                .collect(Collectors.toList());
        List<Integer> evenNumbers2 = list.stream()
                .filter(n -> n % 2 == 0)
                .collect(Collectors.toCollection(LinkedList::new));

        System.out.println(evenNumbers); // class java.util.ArrayList
        System.out.println(evenNumbers2); // class java.util.ArrayList

        System.out.println(evenNumbers.getClass()); // class java.util.ArrayList
        System.out.println(evenNumbers2.getClass()); // class java.util.ArrayList

    }
}
