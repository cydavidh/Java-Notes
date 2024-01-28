```input
5
101 102 504 302 881
```

```java
Scanner scanner = new Scanner(System.in);
        
int len = scanner.nextInt(); // reading a length
int[] array = new int[len];  // creating an array with the specified length
        
for (int i = 0; i < len; i++) {
    array[i] = scanner.nextInt(); // read the next number of the array
}

System.out.println(Arrays.toString(array)); // output the array
```

```output
[101, 102, 504, 302, 881]
```