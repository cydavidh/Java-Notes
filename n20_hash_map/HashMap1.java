package n20_hash_map;

import java.util.HashMap;
import java.util.Map;

public class HashMap1 {
    public static void main(String[] args) {
        HashMap<String, String> postalCodes = new HashMap<>();

        postalCodes.put("00710", "Helsinki");
        postalCodes.put("90014", "Oulu");
        postalCodes.get("00710"); // Helsinki
        postalCodes.get("12345"); // null
        postalCodes.containsKey("00710"); // true // O(1) time complexity // runs get() method internally and see if it
                                          // returns null or not
        postalCodes.containsValue("Helsinki"); // true // O(n) time complexity
        postalCodes.size(); // 1
        postalCodes.keySet(); // [00710, 90014]
        postalCodes.values(); // [Helsinki, Oulu]
        postalCodes.remove("00710"); // returns "Helsinki"
        postalCodes.getOrDefault(postalCodes, "Some String"); // "Not found"

        Map<String, String> maps = new HashMap<>();
        maps.put("ganbatte", "good luck");
        maps.put("hai", "yes");

        for (String key : maps.keySet()) {
            System.out.println(key + ": " + maps.get(key));
        } // OUTPUT: ganbatte: good luck // hai: yes
    }
}
