```java
@Bean
public String address1() {
    return "Green Street, 102";
}

@Bean
public String address2() {
    return "Apple Street, 15";
}

@Bean
public Customer customer(@Qualifier("address2") String address) {
    return new Customer("Clara Foster", address);
}

@Bean
public Customer temporary(@Autowired Customer customer) {
    // Customer{name='Clara Foster', address='Apple Street, 15'}
    System.out.println(customer); 
    return customer;
}
```