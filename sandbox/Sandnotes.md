=====================================================================================================================================
```java
import org.w3c.dom.ls.LSOutput;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

class Main {
    private static void printCommon(int[] firstArray, int[] secondArray) {
        Arrays.stream(firstArray)
                .distinct()
                .filter(n -> Arrays.stream(secondArray)
                .anyMatch(m -> m == n))
                .sorted()
                .forEach(n -> System.out.print(n + " "));
    }

    public static void main(String[] args) {        
        Scanner scanner = new Scanner(System.in);
        int n = scanner.nextInt();
        int[] firstArray = new int [n];
        int[] secondArray = new int [n];
        for (int i = 0; i < n; ++i) { 
            firstArray[i] = scanner.nextInt();
        }
        for (int i = 0; i < n; ++i) { 
            secondArray[i] = scanner.nextInt();
        }

        printCommon(firstArray,secondArray);
    }
}
```
```java
import java.util.*;
import java.util.stream.*;

class Main {
    private static void printCommon(int[] firstArray, int[] secondArray) {
        Set<Integer> firstSet = Arrays.stream(firstArray)
                         .boxed()
                         .sorted()
                         .collect(Collectors.toSet());

        Set<Integer> secondSet = Arrays.stream(secondArray)
            .boxed()
            .collect(Collectors.toSet());

        firstSet.retainAll(secondSet);
            
        firstSet.forEach(n -> System.out.print(n + " "));
    }

    public static void main(String[] args) {        
        Scanner scanner = new Scanner(System.in);
        int n = scanner.nextInt();
        int[] firstArray = new int [n];
        int[] secondArray = new int [n];
        for (int i = 0; i < n; ++i) { 
            firstArray[i] = scanner.nextInt();
        }
        for (int i = 0; i < n; ++i) { 
            secondArray[i] = scanner.nextInt();
        }

        printCommon(firstArray,secondArray);
    }
}
```