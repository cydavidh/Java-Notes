package n77_implement_hashmap_with_array;


import java.util.Scanner;

public class Program {

    public static void main(String[] args) {
        // You can test the class here
        HashMap<Integer, String> map = new HashMap<>();
        map.add(123, "david");
        map.add(444, "charlie");
        map.add(878, "something");
        map.add(999, "stanley");
        System.out.println(map.get(999));
        System.out.println(map.remove(444));
        System.out.println(map);

    }

}
