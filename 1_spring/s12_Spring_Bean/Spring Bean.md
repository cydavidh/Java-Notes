Spring bean is basically an object.
2 kind of beans.

First is method annotated with @Bean (inside classes annotated with @Configuration) that return an instance of an object.

Second is classes annotated with @Component, @Service, @Repository...etc.


@Bean
```java
@Configuration
public class Addresses {

    @Bean
    public String address() {
        return "Green Street, 102";
    }
}
```

@Component
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
=====================================================================================================================

Standard Java Objects
```java
String address = "Green Street, 102";
Customer customer = new Customer("Clara Foster", address);
```

Spring Beans
```java
@Configuration
public class AppConfig {

    @Bean
    public String address() {
        return "Green Street, 102";
    }

    @Bean
    public Customer customer(String address) {
        return new Customer("Clara Foster", address);
    }
}
```

=====================================================================================================================

A Domain Object
```java
class Company {
    private final String name;
    private final List<String> employees;

    Company(String name, List<String> employees) {
        this.name = name;
        this.employees = employees;
    }
}
```

@Bean
A list bean (list of employees)
A Company bean (a company made up of employees)

```java
@Configuration
class CompanyConfiguration {
    @Bean
    public List<String> employees() {
        return List.of(
            "Lillia Barber",
            "Todd Mcloughlin",
            "Jasmine Wu"
        );
    }

    @Bean
    public Company company(@Autowired List<String> employees) {
        return new Company("WorkProject", employees);
    }
}
```


=====================================================================================================================
name of bean can be different, what matters is the return type.
@Bean
```java
@Configuration
public class CopyingConfiguration {

    @Bean
    public CopyingMachine getCopyingMachine(){
        return new CopyingMachine();
    }
}
```
Using the bean, but with another name.
```java
@Component
public class Device {
    private CopyingMachine copyingMachine;

    @Autowired
    public Device(CopyingMachine copyingMachine) {
        this.copyingMachine = copyingMachine;
    }
}
```