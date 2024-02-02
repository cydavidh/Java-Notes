Lambda actually has types.

```java
BiFunction<Integer, Integer, Boolean> isDivisible = (x, y) -> x % y == 0;
```

takes two Integer value and returns Boolean value.

```java
// if it has only one argument "()" are optional
Function<Integer, Integer> adder1 = x -> x + 1;

// with type inference
Function<Integer, Integer> mult2 = (Integer x) -> x * 2;

// with multiple statements
Function<Integer, Integer> adder5 = (x) -> {
    x += 2;
    x += 3;
    return x;
};
```

invoke lambda

```java
boolean result4Div2 = isDivisible.apply(4, 2); // true
boolean result3Div5 = isDivisible.apply(3, 5); // false
```

method that takes a Function type (which is the type that lambda functions are declared as)

```java
private static void printResultOfLambda(Function<String, Integer> function) {
    System.out.println(function.apply("HAPPY NEW YEAR 3000!"));
}

// it returns the length of a string
Function<String, Integer> f = s -> s.length();
printResultOfLambda(f); // it prints 20

// passing without a reference
printResultOfLambda(s -> s.length()); // the result is the same: 20
```
===========================================================================================================================================
the important thing about lambda is that we can parameterize the method with a difference behaviour depending on the situation.

### Without Lambda Expressions

```java
public class ArithmeticOperations {

    public static int add(int a, int b) {
        return a + b;
    }

    public static int subtract(int a, int b) {
        return a - b;
    }

    public static int multiply(int a, int b) {
        return a * b;
    }

    public static void main(String[] args) {
        int resultAdd = add(5, 3);
        int resultSubtract = subtract(5, 3);
        int resultMultiply = multiply(5, 3);

        System.out.println("Addition: " + resultAdd);
        System.out.println("Subtraction: " + resultSubtract);
        System.out.println("Multiplication: " + resultMultiply);
    }
}
```

This approach requires defining a new method for each operation, leading to code duplication and reduced flexibility.

### With Lambda Expressions

Using lambda expressions, we can define a single method that takes an operation as a parameter:

```java
import java.util.function.BiFunction;

public class ArithmeticOperationsLambda {

    public static int operate(int a, int b, BiFunction<Integer, Integer, Integer> operation) {
        return operation.apply(a, b);
    }

    public static void main(String[] args) {
        int resultAdd = operate(5, 3, (a, b) -> a + b);
        int resultSubtract = operate(5, 3, (a, b) -> a - b);
        int resultMultiply = operate(5, 3, (a, b) -> a * b);

        System.out.println("Addition with lambda: " + resultAdd);
        System.out.println("Subtraction with lambda: " + resultSubtract);
        System.out.println("Multiplication with lambda: " + resultMultiply);
    }
}
```

This example demonstrates how lambda expressions can significantly reduce the need for multiple method versions by allowing behavior to be specified at runtime, leading to more concise and flexible code.

===========================================================================================================================================

# Closures

capture value and use it.

only if a context variable has the final keyword or it's effectively final

```java
final String hello = "Hello, ";
Function<String, String> helloFunction = (name) -> hello + name;

System.out.println(helloFunction.apply("John"));
System.out.println(helloFunction.apply("Anastasia"));
```
The lambda expression captured the final variable hello.

The result of this code is:
```
Hello, John
Hello, Anastasia
```

Let's consider an example with an effective final variable.

```java
int constant = 100;
Function<Integer, Integer> adder100 = x -> x + constant;

System.out.println(adder100.apply(200)); // 300
System.out.println(adder100.apply(300)); // 400
```
The variable constant is effectively final and is captured by the lambda expression.