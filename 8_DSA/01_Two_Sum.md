https://leetcode.com/problems/two-sum/description/
```
1. Two Sum
Solved
Easy
Topics
Companies
Hint
Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

 

Example 1:

Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
Example 2:

Input: nums = [3,2,4], target = 6
Output: [1,2]
Example 3:

Input: nums = [3,3], target = 6
Output: [0,1]
 

Constraints:

2 <= nums.length <= 104
-109 <= nums[i] <= 109
-109 <= target <= 109
Only one valid answer exists.
 

Follow-up: Can you come up with an algorithm that is less than O(n2) time complexity?
```

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
time complexity of O(n^2)



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

This approach has a time complexity of O(n) since hash table lookups take constant time on average. It allows us to solve the Two Sum problem efficiently by making just one pass through the array.