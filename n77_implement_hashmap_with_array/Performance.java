package n77_implement_hashmap_with_array;

import java.util.Random;

public class Performance {
    public static void main(String[] args) {
        List<String> myList = new List<>();
        HashMap<String, String> hashMap = new HashMap<>();

        long startTime = System.currentTimeMillis();

        for (int i = 0; i < 1000000; i++) {
            myList.add("" + i);
        }

        long endTime = System.currentTimeMillis();
        long timeTakenForList = endTime - startTime;
        System.out.println("Time taken to add elements to the list: " + timeTakenForList + " milliseconds");

        startTime = System.currentTimeMillis();

        for (int i = 0; i < 1000000; i++) {
            hashMap.add("" + i, "" + i);
        }

        endTime = System.currentTimeMillis();
        long timeTakenForHashMap = endTime - startTime;
        System.out.println("Time taken to add elements to the hashmap: " + timeTakenForHashMap + " milliseconds");

        List<String> elements = new List<>();
        Random randomizer = new Random();
        for (int i = 0; i < 1000; i++) {
            elements.add("" + randomizer.nextInt(2000000));
        }

        long listSearchStartTime = System.nanoTime();
        for (int i = 0; i < elements.size(); i++) {
            myList.contains(elements.getValueOfIndex(i));
        }
        long listSearchEndTime = System.nanoTime();

        long hashMapSearchStartTime = System.nanoTime();
        for (int i = 0; i < elements.size(); i++) {
            hashMap.get(elements.getValueOfIndex(i));
        }
        long hashMapSearchEndTime = System.nanoTime();


        long listSearch = listSearchEndTime - listSearchStartTime;
        System.out.println("List: the search took about " + listSearch / 1000000 + " milliseconds (" +
                listSearch + " nanoseconds.)");

        long hashMapSearch = hashMapSearchEndTime - hashMapSearchStartTime;
        System.out.println("Hash map: the search took about " + hashMapSearch / 1000000 +
                " milliseconds (" + hashMapSearch + " nanoseconds.)");
    }
}
