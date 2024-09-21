Time Complexity: O(n), where n is the total number of pixels in the image
- In worst case, visits every pixel in the image once
- Each pixel visited at most once due to color change check
- Constant time operations for each visited pixel

Space Complexity: O(n) in worst case
- Recursive calls can go as deep as the number of pixels
- Worst case: long snake-like shape of connected pixels
- Best case: O(1) if colors are different or small area to fill

Additional notes:
- Average case often better than worst case
- Performance depends on size of connected area to be filled


```java
package cydavidh.sandbox;

class Solution {
    public int[][] floodFill(int[][] image, int sr, int sc, int color) {
        int originalColor = image[sr][sc];

        // If the new color is the same as the original color, no need to do anything
        if (originalColor == color) {
            return image;
        }

        // Perform the flood fill
        fill(image, sr, sc, originalColor, color);

        return image;
    }

    private void fill(int[][] image, int sr, int sc, int originalColor, int newColor) {
        // Check if the pixel is out of bounds or not the original color
        if (sr < 0 || sr >= image.length || sc < 0 || sc >= image[0].length || image[sr][sc] != originalColor) {
            return;
        }

        // Change the color of the current pixel
        image[sr][sc] = newColor;

        // Recursively call fill on adjacent pixels
        fill(image, sr + 1, sc, originalColor, newColor);  // down
        fill(image, sr - 1, sc, originalColor, newColor);  // up
        fill(image, sr, sc + 1, originalColor, newColor);  // right
        fill(image, sr, sc - 1, originalColor, newColor);  // left
    }
}
```