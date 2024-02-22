`java.util.Random`

generate random numbers of type `int`, `long`, `double`, `float`, and `boolean`.

```java
import java.util.Random;

public class Main {
    public static void main(String[] args) {
        Random rand = new Random();

        int randomInt = rand.nextInt();
        System.out.println("Random Integer: " + randomInt);

        float randomFloat = rand.nextFloat();
        System.out.println("Random Float: " + randomFloat);

        boolean randomBoolean = rand.nextBoolean();
        System.out.println("Random Boolean: " + randomBoolean);
    }
}
```

`nextInt(int bound)` can accept argument as upper bound.
`rand.nextInt(10)` will generate random integers between 0 (inclusive) and 10 (exclusive).

```java
int randomInt = rand.nextInt(10);
System.out.println("Random Integer between 0 and 10: " + randomInt);
```

===========================================================================

For example, we might need a program to give us a temperature between [-30,50]. 
We can do this by first creating random a number between 0 and 80 and then subtracting 30 from it.
```java
Random weatherMan = new Random();
int temperature = weatherMan.nextInt(81) - 30;
```