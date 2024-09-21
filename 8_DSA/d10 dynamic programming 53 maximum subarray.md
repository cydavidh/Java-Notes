# brute force

Time Complexity: O(n²), where n is the length of the input array
- Outer loop runs n times
- Inner loop runs n times in worst case, decreasing with each outer iteration
- Nested loops result in quadratic time complexity
- All operations inside loops are O(1)

```java
import java.sql.Array;

class Solution {
    public static void main(String[] args) {
        int[] arr = new int[]{1, 2, -3, 4, -1};
        System.out.println(maxSubArray(arr));
    }

    public static int maxSubArray(int[] nums) {
        int max = Integer.MIN_VALUE;
        for (int i = 0; i < nums.length; i++) {
            int tempSum = 0;
            for (int j = i; j < nums.length; j++) {
                tempSum += nums[j];
                if (tempSum > max) {
                    max = tempSum;
                }
            }
        }
        return max;
    }
}
```

# Kadane's Algorithm