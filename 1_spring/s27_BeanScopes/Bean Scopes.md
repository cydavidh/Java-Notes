
```java
@Configuration
public class AppConfig {
    @Bean
    public AtomicInteger createCounter() {
        return new AtomicInteger();
    }
}

@Component
public class AppRunner implements CommandLineRunner {
    private final AtomicInteger counter1;
    private final AtomicInteger counter2;

    public AppRunner(AtomicInteger counter1, AtomicInteger counter2) {
        this.counter1 = counter1;
        this.counter2 = counter2;
    }

    @Override
    public void run(String... args) {
        counter1.addAndGet(2);
        counter2.addAndGet(3);
        counter1.addAndGet(5);
        System.out.println(counter1.get());
        System.out.println(counter2.get());
    }
}
```
default: singleton
```
10
10
```

Singleton
```java
@Bean
@Scope("singleton")
public AtomicInteger createCounter() { /* ... */ }
```
```
10
10
```

Prototype
```java
@Bean
@Scope("prototype")
public AtomicInteger createCounter() { /* ... */ }
```
```
7
3
```