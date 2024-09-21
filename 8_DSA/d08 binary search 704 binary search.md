
O(log n), where n is the length of the input array
- While loop reduces search space by half each iteration: O(log n)
- All operations inside the loop (comparisons, arithmetic) are O(1)
- Final check and return statements are O(1)
- No additional space used beyond input (space complexity O(1))


```java
class Solution {
    public int search(int[] nums, int target) {
        int left = 0;
        int right = nums.length - 1;

        while (left < right) {
            int mid = left + (right - left) / 2; // 1/2 = 0, (left + right) / 2 integer overflow

            if (nums[mid] >= target) // >=, because if only >, then left = mid + 1, even if mid == target. 
                right = mid;
            else
                left = mid + 1;
        }

        if (nums[left] != target) return -1; //or nums[right] same thing.

        return left;
    }
}
```

(left + right) / 2 also works, but possible Integer overflow.
Let's say int is 32-bit and l = 2^30 and r = 2^30 + 100:
(l + r) / 2 could overflow before the division
l + (r - l) / 2 will work correctly: (100) / 2 = 50, then 2^30 + 50

java division is always floor, so 1/2 = 0