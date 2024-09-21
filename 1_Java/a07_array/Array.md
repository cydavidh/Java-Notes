

```java
int[] array = new int[] {}; //empty array
int[] array = new int[] {1, 2, 3, 4, 5};
// or
int[] arr = {3, 1, 2, 5, 4};
// or
int[] myArray = new int[5]; // Declare and instantiate an array
myArray[0] = 1; // Set first element
myArray[1] = 2; // Set second element
// ... and so on
        
System.out.println(myArray[0]); // Prints "1"
System.out.println(myArray.length); // Prints "5"
```

Java arrays are objects that store multiple variables of the same type. However, they do not belong to any class and they don't have any methods of their own. 
========================================================================================================
# Add value to array by keeping an int freeIndex

```java
public class List<Type> {

    private Type[] values;
    private int firstFreeIndex;

    public List() {
        this.values = (Type[]) new Object[10];
        this.firstFreeIndex = 0;
    }

    public void add(Type value) {
        this.values[this.firstFreeIndex] = value;
        this.firstFreeIndex++; // same as this.firstFreeIndex = this.firstFreeIndex + 1;
    }
}

```
========================================================================================================

But, Java provides the `Arrays` class in the `java.util` package that provides static methods to manipulate arrays. Here are some of the commonly used methods:

1. `Arrays.sort()`: This method sorts an array in ascending numerical order or alphabetical order for strings.

```java
int[] arr = {3, 1, 2, 5, 4};
Arrays.sort(arr);
// arr is now {1, 2, 3, 4, 5}
```

2. `Arrays.toString()`: This method returns a string representation of the contents of the specified array.

```java
int[] arr = {1, 2, 3, 4, 5};
System.out.println(Arrays.toString(arr));
// prints "[1, 2, 3, 4, 5]"
```

3. `Arrays.copyOf()`: This method copies the specified array, truncating or padding with zeros (if necessary) so the copy has the specified length.

```java
int[] arr = {1, 2, 3, 4, 5};
int[] copyArr = Arrays.copyOf(arr, arr.length);
// copyArr is now {1, 2, 3, 4, 5}
```

4. `Arrays.fill()`: This method assigns a specific value to each element of an array.

```java
int[] arr = new int[5];
Arrays.fill(arr, 10);
// arr is now {10, 10, 10, 10, 10}
```

5. `Arrays.binarySearch()`: This method searches a sorted array for a specified object using the binary search algorithm.

```java
int[] arr = {1, 2, 3, 4, 5};
int index = Arrays.binarySearch(arr, 3);
// index is now 2
```

Remember, these methods are static, so they should be called on the class `Arrays`, not on an instance of the class.


==========================================================================================================

```java
int[] arr = {1, 2, 3, 4, 5};
int length = arr.length;
```

In Java, length is a property of an array, not a method. This is because when an array is created, its size is fixed and cannot be changed. Therefore, length is a final instance variable available to arrays, and it represents the size of the array.

On the other hand, in classes like String, ArrayList, etc., length() or size() are methods because the length can change, and it needs to be computed each time you call the method.