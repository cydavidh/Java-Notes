package n20_hash_map;

import java.util.HashMap;

public class HashMap1 {
    public static void main(String[] args) {
        HashMap<String, String> postalCodes = new HashMap<>();
        postalCodes.put("00710", "Helsinki");
        postalCodes.get("00710"); // Helsinki
        postalCodes.get("12345"); // null
        postalCodes.containsKey("00710"); // true // O(1) time complexity
                                          // runs get() method internally and see if it returns null or not
        postalCodes.containsValue("Helsinki"); // true // O(n) time complexity
        postalCodes.size(); // 1
        System.out.println(postalCodes.keySet());
        postalCodes.keySet(); // [00710]
        postalCodes.values(); // [Helsinki]
        postalCodes.remove("00710"); // returns "Helsinki"
        postalCodes.getOrDefault(postalCodes, "Some String"); // "Not found"
    }
}
