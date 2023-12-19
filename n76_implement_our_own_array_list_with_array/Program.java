package n76_implement_our_own_array_list_with_array;


import java.util.Scanner;

public class Program {
    public static void main(String[] args) {
        List<Integer> asdf = new List<>();
        asdf.add(000);
        asdf.add(111);
        asdf.add(222);
        asdf.add(333);
        asdf.add(444);
        asdf.add(555);
        asdf.add(666);
        asdf.add(777);
        asdf.add(888);
        asdf.add(999);
        asdf.add(101010);
        System.out.println(asdf);
        System.out.println("contains: " + asdf.contains(333));
        System.out.println("find index: " + asdf.findIndexOf(3));
        System.out.print("removed 777: ");
        asdf.remove(777);
        System.out.println(asdf);
        System.out.println("size: " + asdf.size());
        System.out.println("find value: " + asdf.findValueOf(7));
    }
}
