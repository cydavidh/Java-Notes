package cydavidh.springdemo.p07introtocomponents;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class PasswordRunner implements CommandLineRunner {
    private final PasswordGenerator generator;

    @Autowired
    public PasswordRunner(PasswordGenerator generator) {
        this.generator = generator;
    }

    @Override
    public void run(String... args) {
//        System.out.println("A short password: " + generator.generate(5));
//        System.out.println("A long password: " + generator.generate(10));
    }
}