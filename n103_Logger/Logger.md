```java
private static Logger logger = Logger.getLogger(Main.class.getName());

public static void main(String[] args) {
    try {
        String str = null;
        System.out.println(str.length());
    } catch (NullPointerException e) {
        logger.warning("A NullPointerException was caught: " + e.getMessage());
    }
}
```