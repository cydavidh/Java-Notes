```java
class BrokenInvariants {
    public static void main(String[] args) {
        Cat casper = new Cat("Casper", -1);
    }
}

class Cat {
    String name;
    int age;
    public Cat(String name, int age) {
        assert (age >= 0) : "Invalid age";
        this.name = name;
        this.age = age;
    }
}

```

add -ea flag

```java
public class Util {
    public static void swapInts(int[] ints) {
        int temp = ints[0];
        ints[0] = ints[1];
        ints[1] = temp;
    }
}
```

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertArrayEquals;

public class UtilTest {
    @Test
    public void testSwapInts() {
        int[] ints = {1, 2};
        Util.swapInts(ints);
        System.out.println(ints[0]);
        assertArrayEquals(new int[] {2, 1}, ints);
    }
}
```