https://leetcode.com/problems/two-sum/description/

brute force
```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        int[] temp = new int [2];
        for (int i = 0; i < nums.length; i++) {
            for (int j = i+1; j < nums.length; j++) {
                if (nums[i] + nums[j] == target) {
                    temp[0] = i;
                    temp[1] = j;
                }
            }
        }
        return temp;
    }
}
```

hash table
```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> hashTable = new HashMap<>();

        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (hashTable.containsKey(complement)) {
                return new int[]{hashTable.get(complement), i};
            }
            hashTable.put(nums[i], i);
        }

        //return new int[] {};
        return new int[0];
    }
}
```