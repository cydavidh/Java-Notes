# Hashmap

//Instance method
str.toCharArray
hashMap.getOrDefault(key, default value)

O(n), where n is the length of the longer string
- Loop through each string once: O(n)
- HashMap operations (put() and getOrDefault()) are O(1)
- Final loop through HashMap is O(1) as it's bounded by alphabet size
- All other operations are constant time

```java
package cydavidh.sandbox;

import java.util.HashMap;
import java.util.Map;

class Sandbox {
    public static void main(String[] args) {
        System.out.println(isAnagram("hello", "holle"));
    }

    static boolean isAnagram(String s, String t) {
        Map<Character, Integer> hashMap = new HashMap<>();

        for (char c : s.toCharArray()) {
            hashMap.put(c, hashMap.getOrDefault(c, 0) + 1);
        }

        for (char c : t.toCharArray()) {
            hashMap.put(c, hashMap.getOrDefault(c, 0) - 1);
        }

        for (int x : hashMap.values()) {
            if (x != 0) {
                return false;
            }
        }
        return true;
    }
}
```

# Sorting

O(n log n), where n is the length of the longer string
- Converting strings to char arrays: O(n)
- Arrays.sort() uses dual-pivot Quicksort: O(n log n)
- Arrays.equals() compares elements: O(n)
- Overall complexity dominated by sorting: O(n log n)

```java
package cydavidh.sandbox;

import java.util.Arrays;

class Sandbox {
    public static void main(String[] args) {
        System.out.println(isAnagram("asdf", "fdsa"));
    }

    static boolean isAnagram(String s, String t) {
        char[] temp = s.toCharArray();
        char[] temp2 = t.toCharArray();

        Arrays.sort(temp);
        Arrays.sort(temp2);

        if (Arrays.equals(temp, temp2)) {
            return true;
        }

        return false;
    }
}
```


# frequency count

O(n), where n is the length of the longer string
- Two loops through strings s and t: O(n)
- Fixed-size array operations (count[x - 'a']) are O(1) 
- Final loop through count array is O(1), as size is fixed at 26
- All other operations are constant time
- 
```java
class Solution {
    public boolean isAnagram(String s, String t) {
        int[] count = new int[26];

        // Count the frequency of characters in string s
        for (char x : s.toCharArray()) {
            count[x - 'a']++; // 'z' (ASCII 122) - 'a' (ASCII 97) = 25
//            'a' - 'a' = 97 - 97 = 0
//            'b' - 'a' = 98 - 97 = 1
//            'z' - 'a' = 122 - 97 = 25
        }

        // Decrement the frequency of characters in string t
        for (char x : t.toCharArray()) {
            count[x - 'a']--;
        }

        // Check if any character has non-zero frequency
        for (int val : count) {
            if (val != 0) {
                return false;
            }
        }

        return true;
    }
}
```
