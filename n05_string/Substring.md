`substring()` is a method of `String`.

public String substring(int startIndex)
public String substring(int startIndex, int endIndex)

beginIndex :  the begin index, inclusive.
endIndex :  the end index, exclusive.

```java
public class Main {
    public static void main(String[] args) {
        String str = "Assumption";

        String substr1 = str.substring(1);
        System.out.println(substr1); // Outputs "ssumption"

        String substr2 = str.substring(1, 2);
        System.out.println(substr2); // Outputs "s"
    }
}
```