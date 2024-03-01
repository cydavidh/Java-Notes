package cydavidh.springdemo.p06introductiontospringbeans;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Addresses {

    @Bean
    public String address1() {
        return "Green Street, 102";
    }

    @Bean
    public String address2() {
        return "Apple Street, 15";
    }

    @Bean
    public Customer customer(String address1) {
        return new Customer("Clara Foster", address1);
    }

    @Bean
    public Customer temporary(@Autowired Customer customer) {

//        System.out.println(customer); // output: Customer{name='Clara Foster', address='Apple Street, 15'}
        return customer;
    }

}
