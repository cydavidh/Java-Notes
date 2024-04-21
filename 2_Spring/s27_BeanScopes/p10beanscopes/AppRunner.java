package cydavidh.springdemo.p10beanscopes;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.concurrent.atomic.AtomicInteger;

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
//        System.out.println(counter1.get());
//        System.out.println(counter2.get());
    }
}