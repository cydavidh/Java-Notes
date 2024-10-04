# brute force

generate all subarrays.

Time Complexity: O(n³), where n is the length of the input array

- Three nested loops
- Each loop iterates over all elements in the array
- O(n) for each loop
- O(n) * O(n) * O(n) = O(n³)

```java
class Solution {
    public static void main(String[] args) {
        int[] arr = new int[]{1, -1, -3, 49, -4};
        System.out.println(maxSubArray(arr));
    }

    public static int maxSubArray(int[] nums) {
        int max = Integer.MIN_VALUE;
        for (int i = 0; i < nums.length; i++) {
            for (int j = i; j < nums.length; j++) {
                int tempSum = 0;
                for (int k = i; k <= j; k++) {
                    tempSum += nums[k];
                }
                if (tempSum > max) {
                    max = tempSum;
                }
            }
        }
        return max;
    }
}
```

# brute force optimized

so instead of using a third loop to calculate the array with the start and end index, we can just add the next element
to the sum.
array: 1, 2, 3, 4, 5
start index: 1
end index: 2
when end index moves on to 3 in the second loop, we can just get the previous sum, which is 3, and then add 3 to it.
In the previous approach, when end index moves on to 3, we have to freshly calculate the sum of the array again.

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

Time Complexity: O(n), where n is the length of the input array

- Single pass through the array with one loop
- Each element is processed once
- All operations inside the loop are O(1)

Space Complexity: O(1) - constant space

- The number of variables doesn't change with the input size.
- Whether the input array has 10 elements or 10 million elements, we still use the same 4 variables. (temp, max, num, i)
- In Big O notation, we typically ignore constants. O(4) is simplified to O(1).

code I wrote after reading, where it discards the previous sum if it's negative.
```java
package cydavidh.sandbox;

import java.sql.Array;

class Solution {
    public static void main(String[] args) {
        int[] arr = new int[]{1, -1, -3, 49, -4};
        System.out.println(maxSubArray(arr));
    }

    public static int maxSubArray(int[] nums) {
        int tempMax = nums[0];
        int max = nums[0];
        for (int i = 1; i < nums.length; i++) {
            int num = nums[i];
            if (tempMax < 0) {
                tempMax = num;
            } else {
                tempMax += num;
            }
            max = Math.max(tempMax, max);
        }
        return max;
    }
}
```

this one finds the max between the current element, and the sum of the elements before it.
```java

package cydavidh.sandbox;

class Solution {
    public static void main(String[] args) {
        int[] arr = new int[]{1, -1, -3, 49, -4};
        System.out.println(maxSubArray(arr));
    }

    public static int maxSubArray(int[] nums) {
        int tempMax = nums[0];
        int max = nums[0];
        for (int i = 1; i < nums.length; i++) {
            int num = nums[i];
            tempMax = Math.max(tempMax + num, num);
            max = Math.max(tempMax, max);
        }
        return max;
    }
}

```

# divide and conquer

Time Complexity: O(n log n), where n is the length of the input array, because the array is divided in half at each
level of recursion.

## div and conquer: solution 1

This solution finds three sums, left half, right half, and the max crossing array (meaning the middle element included),
and then finds the max.

```java
public class Solution {
    public int maxSubArray(int[] nums) {
        return findMaxSubarray(nums, 0, nums.length - 1);
    }

    public static int findMaxSubarray(int[] A, int left, int right) {
        if (left == right) {
            return A[left];
        } else {
            int mid = (left + right) / 2; //don't need to floor divide because left and right are index numbers
            int leftSum = findMaxSubarray(A, left, mid);
            int rightSum = findMaxSubarray(A, mid + 1, right);
            int crossSum = findMaxCrossingSubarray(A, left, mid, right);
            return Math.max(Math.max(leftSum, rightSum), crossSum);
        }
    }

    public static int findMaxCrossingSubarray(int[] A, int low, int mid, int high) {
        int leftSum = 0;
        int maxLeftSum = Integer.MIN_VALUE;
        for (int i = mid; i >= low; i--) { //from mid to left
            leftSum += A[i];
            maxLeftSum = Math.max(maxLeftSum, leftSum);
        }

        int rightSum = 0;
        int maxRightSum = Integer.MIN_VALUE;
        for (int j = mid + 1; j <= high; j++) { //from mid to right
            rightSum += A[j];
            maxRightSum = Math.max(maxRightSum, rightSum);
        }

        return maxLeftSum + maxRightSum;
    }

    public static void main(String[] args) {
        int[] testArray = {-2, 1, -3, 4, -1, 2, 1, -5, 4};
        int maxSum = findMaxSubarray(testArray, 0, testArray.length - 1);
        System.out.println("Maximum subarray sum: " + maxSum);
    }
}
```

## div and conquer: solution 2

This solution singles out the middle element and uses mid - 1 for the left half sum, therefore it uses left > right (
empty array) as the base case to avoid stack overflow.
otherwise it's the same, it finds the maxcrossingarray and the left and right half sum.

```java
class Solution {
    private int[] numsArray;

    public int maxSubArray(int[] nums) {
        numsArray = nums;

        // Our helper function is designed to solve this problem for
        // any array - so just call it using the entire input!
        return findBestSubarray(0, numsArray.length - 1);
    }

    private int findBestSubarray(int left, int right) {
        // Base case - empty array.
        if (left > right) {
            return Integer.MIN_VALUE;
        }

        int mid = Math.floorDiv(left + right, 2);
        int curr = 0;
        int bestLeftSum = 0;
        int bestRightSum = 0;

        // Iterate from the middle to the beginning.
        for (int i = mid - 1; i >= left; i--) {
            curr += numsArray[i];
            bestLeftSum = Math.max(bestLeftSum, curr);
        }

        // Reset curr and iterate from the middle to the end.
        curr = 0;
        for (int i = mid + 1; i <= right; i++) {
            curr += numsArray[i];
            bestRightSum = Math.max(bestRightSum, curr);
        }

        // The bestCombinedSum uses the middle element and the best
        // possible sum from each half.
        int bestCombinedSum = numsArray[mid] + bestLeftSum + bestRightSum;

        // Find the best subarray possible from both halves.
        int leftHalf = findBestSubarray(left, mid - 1);
        int rightHalf = findBestSubarray(mid + 1, right);

        // The largest of the 3 is the answer for any given input array.
        return Math.max(bestCombinedSum, Math.max(leftHalf, rightHalf));
    }
}
```

this one just adds another base case

```java
class Solution {
    private int[] numsArray;

    public int maxSubArray(int[] nums) {
        numsArray = nums;

        // Our helper function is designed to solve this problem for
        // any array - so just call it using the entire input!
        return findBestSubarray(0, numsArray.length - 1);
    }

    private int findBestSubarray(int left, int right) {
        // Base case
        if (left == right) {
            return numsArray[left];
        }
        if (left > right) {
            return Integer.MIN_VALUE;
            //return numsArray[left];
            /* Why returning numsArray[left] also works:
             * When left > right, we're looking at an empty subarray.
             * [1,2,3]
             * [1] [3]
             * when we reach the single element, we returned it
             * we kee
             */
        }

        int mid = Math.floorDiv(left + right, 2);
        int curr = 0;
        int bestLeftSum = 0;
        int bestRightSum = 0;

        // Iterate from the middle to the beginning.
        for (int i = mid - 1; i >= left; i--) {
            curr += numsArray[i];
            bestLeftSum = Math.max(bestLeftSum, curr);
        }

        // Reset curr and iterate from the middle to the end.
        curr = 0;
        for (int i = mid + 1; i <= right; i++) {
            curr += numsArray[i];
            bestRightSum = Math.max(bestRightSum, curr);
        }

        // The bestCombinedSum uses the middle element and the best
        // possible sum from each half.
        int bestCombinedSum = numsArray[mid] + bestLeftSum + bestRightSum;

        // Find the best subarray possible from both halves.
        int leftHalf = findBestSubarray(left, mid - 1);
        //int leftHalf = findBestSubarray(left, mid);  
        //you can also choose to get rid of the base case left > right and use findBestSubarray(left, mid);
        //if you get rid of the base case and use (left, mid - 1), stackoverflow because no case to stop 
        //although calculating till mid is not ideal becuase we already stored the mid element, but this 
        //prevents calls like (3,2) which overflows the stack.
        int rightHalf = findBestSubarray(mid + 1, right);

        // The largest of the 3 is the answer for any given input array.
        return Math.max(bestCombinedSum, Math.max(leftHalf, rightHalf));
    }
}
```

this one is the same as solution 1. it uses one element left as base case, and then finds the best crossing array, and
then the left half and right half, lastly finds the max.

```java
package cydavidh.sandbox;

class Solution {
    public static void main(String[] args) {
        System.out.println(maxSubArray(new int[] {1,2,3,4}));
    }

    static int[] numsArray;

    static int maxSubArray(int[] nums) {
        numsArray = nums;

        // Our helper function is designed to solve this problem for
        // any array - so just call it using the entire input!
        return findBestSubarray(0, numsArray.length - 1);
    }

    static int findBestSubarray(int left, int right) {
        // Base case - empty array.
        if (left == right) {
            return numsArray[left];
        }

        int mid = Math.floorDiv(left + right, 2);
        int curr = 0;
        int bestLeftSum = 0;
        int bestRightSum = 0;

        // Iterate from the middle to the beginning.
        for (int i = mid; i >= left; i--) {
            curr += numsArray[i];
            bestLeftSum = Math.max(bestLeftSum, curr);
        }

        // Reset curr and iterate from the middle to the end.
        curr = 0;
        for (int i = mid + 1; i <= right; i++) {
            curr += numsArray[i];
            bestRightSum = Math.max(bestRightSum, curr);
        }

        // The bestCombinedSum uses the middle element and the best
        // possible sum from each half.
        int bestCombinedSum = bestLeftSum + bestRightSum;

        // Find the best subarray possible from both halves.
        int leftHalf = findBestSubarray(left, mid);
        int rightHalf = findBestSubarray(mid + 1, right);

        // The largest of the 3 is the answer for any given input array.
        return Math.max(bestCombinedSum, Math.max(leftHalf, rightHalf));
    }
}
```