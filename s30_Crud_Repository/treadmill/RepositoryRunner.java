package cydavidh.springdemo.p12crudrepository;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class RepositoryRunner implements CommandLineRunner {
    private final TreadmillRepository repository;

    public RepositoryRunner(TreadmillRepository repository) {
        this.repository = repository;
    }

    @Override
    public void run(String... args) {
//        // work with the repository here
//        System.out.println("Before save:");
//        doWeHaveSomethingInDb();
//
//        System.out.println("Saving...");
//        repository.save(new Treadmill("aaa", "Yamaguchi runway"));
//        repository.save(new Treadmill("bbb", "Yamaguchi runway pro-x"));
//        repository.save(new Treadmill("ccc", "Yamaguchi max"));
//        System.out.println("After save:");
//        doWeHaveSomethingInDb();
//
//        System.out.println("Looking for the treadmill with code='non-existing-code'... ");
//        Optional<Treadmill> treadmill = repository.findById("non-existing-code");
//        String result = treadmill.map(this::createTreadmillView).orElse("Not found");
//        System.out.println(result);
//
//        Iterable<Treadmill> treadmills = repository.findAll();
//        for (Treadmill tempmill : treadmills) {
//            System.out.println(createTreadmillView(tempmill));
//        }
//
//        Optional<Treadmill> existingTreadmill = repository.findById("aaa");
//
//        String existing = existingTreadmill
//                .map(this::createTreadmillView)
//                .orElse("Not found");
//
//        System.out.println("Before update: " + existing);
//        System.out.println("Updating...");
//
//        existingTreadmill.ifPresent(treadmillTemp -> {
//            treadmillTemp.setModel("Yamaguchi runway-x");
//            repository.save(treadmillTemp);
//        });
//
//        Optional<Treadmill> updatedTreadmill = repository.findById("aaa");
//        String updated = updatedTreadmill
//                .map(this::createTreadmillView)
//                .orElse("Not found");
//
//        System.out.println("After update: " + updated);
//
//        System.out.println("Before delete: ");
//        printAllTreadmills();
//
//        System.out.println("Deleting...");
//        repository.deleteById("ccc");
//
//        System.out.println("After delete: ");
//        printAllTreadmills();
//
//        System.out.println("Before delete: ");
//        printAllTreadmills();
//
//        System.out.println("Deleting...");
//        Optional<Treadmill> proXTreadmill = repository.findById("bbb");
//        proXTreadmill.ifPresent(
//                treadmill2 -> {
//                    repository.delete(treadmill2);
//                }
//        );
//
//        System.out.println("After delete: ");
//        printAllTreadmills();
    }
    private void doWeHaveSomethingInDb() {
        long count = repository.count();
        if (count > 0) {
            System.out.printf("Db has %d treadmill(s)%n", count);
        } else {
            System.out.println("Db is empty");
        }
    }

    private String createTreadmillView(Treadmill treadmill) {
        return "Treadmill(code: %s, model: %s)"
                .formatted(treadmill.getCode(), treadmill.getModel());
    }

    private void printAllTreadmills() {
        Iterable<Treadmill> treadmills = repository.findAll();
        for (Treadmill treadmill : treadmills) {
            System.out.println(createTreadmillView(treadmill));
        }
    }

}

//    @Bean
//    public CommandLineRunner demo(TreadmillRepository repository) {
//        return (args) -> {
//            // Create a new Treadmill
//            repository.save(new Treadmill("AAA", "Yamaguchi Runway"));
//
//            // Read the Treadmill from the database
//            System.out.println("Treadmill found with findAll():");
//            System.out.println("-------------------------------");
//            for (Treadmill treadmill : repository.findAll()) {
//                System.out.println(treadmill.getModel());
//            }
//            System.out.println();
//        };
//    }