package cydavidh.springdemo.p10beanscopes;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

import java.util.concurrent.atomic.AtomicInteger;

@Configuration
public class AppConfig {
    @Bean
    @Scope("prototype")
    public AtomicInteger createCounter() {
        return new AtomicInteger();
    }
}