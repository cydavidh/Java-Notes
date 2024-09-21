```java
package cydavidh.sandbox;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Arrays;

class Solution {
    public int maxSubArray(int[] nums) {
        int max = Integer.MIN_VALUE;
        for (int i = 0; i < nums.length; i++) {
            for (int j = i; j < nums.length; j++) {
                int tempI = i;
                int tempSum = 0;
                while (tempI <= j) {
                    tempSum += nums[tempI];
                    tempI++;
                }
                if (tempSum > max) {
                    max = tempSum;
                }
            }
        }
        return max;
    }

    public static void main(String[] args) {
        Solution solution = new Solution();
        try {
            int[] nums = readTestCaseFromFile("/testcase.txt");
            System.out.println("Input array: " + Arrays.toString(nums));

            long startTime = System.nanoTime();
            int result = solution.maxSubArray(nums);
            long endTime = System.nanoTime();

            long duration = (endTime - startTime);
            double milliseconds = duration / 1_000_000.0;

            System.out.println("Maximum subarray sum: " + result);
            System.out.printf("Execution time: %.3f ms%n", milliseconds);
        } catch (IOException e) {
            System.err.println("Error reading test case: " + e.getMessage());
        }
    }

    private static int[] readTestCaseFromFile(String fileName) throws IOException {
        InputStream inputStream = Solution.class.getResourceAsStream(fileName);
        if (inputStream == null) {
            throw new IOException("File not found: " + fileName);
        }
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
            String line = reader.readLine();
            line = line.substring(1, line.length() - 1); // Remove square brackets
            String[] numberStrings = line.split(",");
            int[] numbers = new int[numberStrings.length];
            for (int i = 0; i < numberStrings.length; i++) {
                numbers[i] = Integer.parseInt(numberStrings[i].trim());
            }
            return numbers;
        }
    }
}
```

testcase.txt
```
[-57,9,-72,-72,-62,45,-97,24,-39,35,-82,-4,-63,1,-93,42]
```