```java
import java.util.function.IntFunction;

public class Main {
    public static void main(String[] args) {
        IntFunction<String> checkValue = (x) -> {
            if (x > 10) {
                return "Greater than 10";
            } else {
                return "10 or Less";
            }
        };

        System.out.println(checkValue.apply(15)); // Outputs: "Greater than 10"
        System.out.println(checkValue.apply(10)); // Outputs: "10 or Less"
    }
}

```

```java
import java.util.function.IntBinaryOperator;

public class Main {
    public static void main(String[] args) {
        IntBinaryOperator maxOperator = (x, y) -> x > y ? x : y;
        
        int result = maxOperator.applyAsInt(10, 20);
        System.out.println(result); // Outputs: 20
    }
}

```

```java
import java.util.function.UnaryOperator;

class PrefixSuffixOperator {

    public static final String PREFIX = "__pref__";
    public static final String SUFFIX = "__suff__";

    public static UnaryOperator<String> operator = (x) -> PREFIX + x.trim() + SUFFIX;
}
```