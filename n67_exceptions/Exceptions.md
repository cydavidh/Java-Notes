2. **Checked vs Unchecked Exceptions**: `Checked` exceptions are exceptions that are checked at compile time. If a method might throw a checked exception, it must declare it using a `throws` clause, or handle it with a try-catch block. `Unchecked` exceptions, also known as runtime exceptions, do not need to be declared or handled explicitly, although it can be good practice to do so.

3. **Common Checked Exceptions**: A common example of a checked exception is `IOException`, which is often thrown when performing I/O operations.

4. **Common Unchecked Exceptions**: Examples of unchecked exceptions include `NullPointerException`, `IndexOutOfBoundsException`, `ArithmeticException`, `IllegalArgumentException`, `ClassCastException`, and `NumberFormatException`. Unchecked exceptions do not need to be declared or handled explicitly

5. **Handling Exceptions**: Exceptions can be handled using try-catch blocks. This allows you to write code that is executed when an exception occurs, such as logging an error message.

Sure, here's the updated summary with examples for throwing exceptions and handling them:

6. **Throwing Exceptions**: You can throw an exception using the `throw` keyword. This is often used in conjunction with creating a new instance of an exception class.

   - **Unchecked Exception Example**: Throwing an `IllegalArgumentException`, which is a `RuntimeException` and therefore unchecked. This might be used when a method is passed an argument that is not valid.

     ```java
     public void setAge(int age) {
         if (age < 0) {
            throw new IllegalArgumentException("Age cannot be negative");
         }
         this.age = age;
     }
     ```

     To handle this exception, you could use a try-catch block when calling `setAge`:

     ```java
     try {
         setAge(-1);
     } catch (IllegalArgumentException e) {
         System.out.println("Caught exception: " + e.getMessage());
     }
     ```

   - **Checked Exception Example**: Throwing an `IOException`, which is a checked exception. This might be used when an I/O error occurs, such as when a file cannot be read.
     ```java
     public void readFile(String filename) throws IOException {
         File file = new File(filename);
         if (!file.exists()) {
             throw new IOException("File does not exist");
         }
         // Continue with reading the file...
     }
     ```
     To handle this exception, you could use a try-catch block when calling `readFile`:
     ```java
     try {
         readFile("nonexistent.txt");
     } catch (IOException e) {
         System.out.println("Caught exception: " + e.getMessage());
     }
     ```

In both examples, the exception is thrown in the method body and then caught and handled in a try-catch block when the method is called.

7. **Exception Propagation**: If a method does not handle an exception, it is propagated up the call stack to the method that called it. This continues until the exception is caught and handled, or until it reaches the `main` method and causes the program to terminate.

8. **Exception in Main Method**: If an exception is thrown in the `main` method and it's not caught, the JVM will terminate the program and print the exception's stack trace to the standard error output. This applies to both checked exceptions declared with a `throws` clause and unchecked exceptions.
