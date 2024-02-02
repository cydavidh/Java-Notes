package sandbox;

import java.util.List;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeSet;

public class Sandbox {
    public static void main(String[] args) {
        int[] arr = new int[5];
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        Set<Integer> set = new TreeSet<>(Set.of(arr));

    }
}
