Spring bean is basically an object.
2 kind of beans.

First is method annotated with @Bean (inside classes annotated with @Configuration) that return an instance of an object.

Second is classes annotated with @Component, @Service, @Repository...etc.


First
```java
@Configuration
public class Addresses {

    @Bean
    public String address() {
        return "Green Street, 102";
    }
}
```

Second
```java
@Component
public class PasswordGenerator {
    private static final String CHARACTERS = "abcdefghijklmnopqrstuvwxyz";
    private static final Random random = new Random();

    public String generate(int length) {
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(CHARACTERS.length());
            result.append(CHARACTERS.charAt(index));
        }

        return result.toString();
    }
}
```