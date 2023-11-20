package n20_hash_map;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class HashMap1 {
    public static void main(String[] args) {
        Map<String, String> postalCodes = new HashMap<>(); // upcast to Map because we program to interface

        postalCodes.put("00710", "Helsinki");
        postalCodes.put("90014", "Oulu");
        postalCodes.get("00710"); // returns "Helsinki"
        postalCodes.get("12345"); // returns null
        postalCodes.containsKey("00710"); // returns true // O(1) time complexity // runs get() method internally and
                                          // see if it returns null or not
        postalCodes.containsValue("Helsinki"); // returns true // O(n) time complexity
        postalCodes.size(); // returns 1
        postalCodes.keySet(); // returns [00710, 90014]
        postalCodes.values(); // returns [Helsinki, Oulu]
        postalCodes.remove("00710"); // returns "Helsinki"
        postalCodes.getOrDefault(90014, "Some String"); // returns "Oulu"

        Map<String, String> maps = new HashMap<>();
        maps.put("ganbatte", "good luck");
        maps.put("ohaiyou", "good morning");

        // printing the keys and values
        for (String key : maps.keySet()) {
            System.out.println(key + ": " + maps.get(key)); // ganbatte: good luck // ohaiyou: good morning
        }
        Iterator<String> iterator = maps.keySet().iterator();
        while (iterator.hasNext()) {
            System.out.println(iterator.next()); // ganbatte // ohaiyou
        }
    }
}
