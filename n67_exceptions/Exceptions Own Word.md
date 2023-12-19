Unchecked exception: `NullPointerException`, `IndexOutOfBoundsException`,
`ArithmeticException`, `IllegalArgumentException`, `ClassCastException`, and
`NumberFormatException` dont have to handle, dont worry about them

Checked exception: `FileNotFoundException`, `IOException`, which is often thrown
when performing I/O operations. Throw or Handle it with try-catch

If throw:

```java
public void method(Type object) throws Exception {}
```

```java
public void readFile(String filename) throws IOException {
    File file = new File(filename);
    if (!file.exists()) {
        throw new IOException("File does not exist");
    }
    // reads File
    try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
        String line;
        while ((line = reader.readLine()) != null) {
            // Process the line...
        }
    }
}
```

/\*\* The decision to throw or handle an exception often depends on the context
and the specific requirements of your application.

    In the provided code, the `IOException` is thrown when the file does not exist because this is a condition that the `readFile` method cannot recover from. If the file doesn't exist, there's nothing more that `readFile` can do, so it throws an exception to let the caller know that something went wrong.

    On the other hand, the `BufferedReader` is used in a try-with-resources statement. This is a special kind of try statement that automatically closes the resources at the end of the statement. If an `IOException` occurs while reading the file, it will be caught and the `BufferedReader` will be closed properly. This is done to ensure that resources are always cleaned up, even when an error occurs.

    In general, you should throw exceptions for conditions that your method cannot recover from, and catch exceptions when you can take an alternative action.

\*/

Then propagated up call stack to method that called it. until it's caught and
handled, or reach `main` and program terminates.

Handle example in `main`:

```java
public class Main {
    public static void main(String[] args) {
        FileReader fileReader = new FileReader();
        try {
            fileReader.readFile("example.txt");
        } catch (IOException e) {
            System.out.println("An error occurred while reading the file: " + e.getMessage());
            // Handle the exception (e.g., log the error, notify the user, etc.)
            // Output: "An error occurred while reading the file: File does not exist"
        }
    }
}
```
