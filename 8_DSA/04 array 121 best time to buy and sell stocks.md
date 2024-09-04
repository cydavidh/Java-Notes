https://leetcode.com/problems/best-time-to-buy-and-sell-stock/description/

# my first solution
O(n)

```java
package cydavidh.sandbox;

import java.util.ArrayList;

class Sandbox {
    public static void main(String[] args) {
        int[] temp = new int[]{7, 1, 3, 6, 4};
        int[] temp2 = new int[]{3, 2, 1};
        System.out.println(maxprofit(temp));
        System.out.println(maxprofit(temp2));
    }

    static int maxprofit(int[] prices) {
        int min = Integer.MAX_VALUE;
        int max = 0;
        int dif = 0;
        for (int i = 0; i < prices.length; i++) {
            if (prices[i] < min) {
                min = prices[i];
                max = prices[i];
            }

            if (prices[i] > max) {
                max = prices[i];
            }

            int temp = max - min;

            if (temp > dif) {
                dif = temp;
            }
        }
        return dif;
    }
}
```

# one pass
this one removes the unnecessary max from my solution.

```java
    static int maxprofit(int[] prices) {
        int min = Integer.MAX_VALUE;
        int dif = 0;
        for (int i = 0; i < prices.length; i++) {
            if (prices[i] < min) {
                min = prices[i];
            }

            int temp = prices[i] - min;

            if (temp > dif) {
                dif = temp;
            }
        }
        return dif;
    }
```

# brute force
does not pass the time limit on leetcode
O(n^2) because it uses nested for loops (n*n).

```java
class Solution {
    public int maxProfit(int[] prices) {
        int maxdif = 0;

        for (int i = 0; i < prices.length; i++) {
            for (int j = i + 1; j < prices.length; j++) {
                if (prices[j] > prices[i]) {
                    int temp = prices[j] - prices[i];
                    if (temp > maxdif) {
                        maxdif = temp;
                    }
                }
            }
        }
        return maxdif;
    }
}
```