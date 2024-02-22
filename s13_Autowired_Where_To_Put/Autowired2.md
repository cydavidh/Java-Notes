@Autowired basically directly provides the dependency bean.

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
    public Customer customer(@Autowired String address) {
        return new Customer("Clara Foster", address);
    }
}
```

Here it directly provides the address bean as dependency to the customer.

So right now the customer bean is an object of Type Customer and holds the value of Clara Foster and Green Street 102

You can check with another bean with customer dependency and then print the customer.

```java
@Bean
public Customer temporary(@Autowired Customer customer) {
    System.out.println(customer);
    return customer;
}
```
```
Customer{name='Clara Foster', address='Green Street, 102'}
```

If you don't do inject the dependency this way with @Autowired, you will have to manually provide the address when calling this method to create the Customer bean.

```java
@Bean
public Customer customer(String address) { //no @Autowired, but this is just an idea, Spring will still automatically inject cuz it's smart.
    return new Customer("Clara Foster", address);
}
```

The manual method without @Autowired you basically call the method directly wherever you have the address value available.
This could be in another configuration class, a service class, or even within the main application class itself, depending on where you have or obtain the address string.

Example of using it in another class:

```java
@Service
public class SomeService {
    private final ApplicationContext context;
    private final String address;

    public SomeService(ApplicationContext context, String address) {
        this.context = context;
        this.address = address;
    }

    public void createCustomer() {
        Customer customer = context.getBean("customer", this.address);  //instead of Customer customer = new Customer(this.address)
        // use the customer object...
    }
}
```