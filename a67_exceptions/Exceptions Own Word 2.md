printStackTrace()

```java
try {
    int result = 10 / 0; // This will throw an ArithmeticException
} catch (Exception e) {
    e.printSTackTrace(); // NOT getStackTrace()
}
```

```
java.lang.ArithmeticException: / by zero
    at Main.main(Main.java:4)
```
