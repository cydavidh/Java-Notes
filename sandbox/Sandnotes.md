```java
class Customer {
    private final String name;
    private final String address;

    Customer(String name, String address) {
        this.name = name;
        this.address = address;
    }

    // getters
}

@Configuration
public class Addresses {

    @Bean
    public String address() {
        return "Green Street, 102";
    }
}

@SpringBootApplication
public class DemoSpringApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoSpringApplication.class, args);
    }

    @Bean
    public Customer customer(Addresses addresses) {
        String address = addresses.address();
        return new Customer("Clara Foster", address);
    }

    @Bean
    public Customer customer(@Autowired String address) {
        return new Customer("Clara Foster", address);
    }
}
```

```java
public class MyService {
    private final Dependency dependency;

    public MyService(Dependency dependency) {
        this.dependency = dependency;
    }
}

@Component
public class Dependency {
    private String data;

    public Dependency() {
        // Constructor logic
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public void performTask() {
        // Functionality that MyService depends on
    }
}

@SpringBootApplication
public class DemoSpringApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoSpringApplication.class, args);
    }

    @Bean
    public MyService myService(Dependency dependency) {
        return new MyService(dependency);
    }
}
```