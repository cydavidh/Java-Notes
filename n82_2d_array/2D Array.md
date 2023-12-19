```java
int[][] matrix = {
        { 3, 2, 7, 6 },
        { 2, 4, 1, 0 },
        { 3, 2, 1, 0 }
};

int[][] matrix2 = new int[2][3];
matrix2[0][1] = 4;
matrix2[1][1] = 1;
matrix2[1][0] = 8;

for (int row = 0; row < matrix.length; row++) {
    for (int column = 0; column < matrix[row].length; column++) {
        int value = matrix[row][column];
        System.out.print(value + " ");
    }
    System.out.println();
}
```

```output
3 2 7 6 
2 4 1 0 
3 2 1 0 
```