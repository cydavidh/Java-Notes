```java
@Indexed
public interface Repository<T, ID> {
}
```
```java
@NoRepositoryBean
public interface CrudRepository<T, ID> extends Repository<T, ID> {
    // CREATE/UPDATE methods
    <S extends T> S save(S entity);
    <S extends T> Iterable<S> saveAll(Iterable<S> entities);

    // READ methods
    Optional<T> findById(ID id);
    boolean existsById(ID id);
    Iterable<T> findAll();
    Iterable<T> findAllById(Iterable<ID> ids);
    long count();

    // DELETE methods
    void deleteById(ID id);
    void delete(T entity);
    void deleteAllById(Iterable<? extends ID> ids);
    void deleteAll(Iterable<? extends T> entities);
    void deleteAll();
}
```
```java
// an annotation goes here
public class Treadmill {
    private String code;
    private String model;

    // constructors, getters, setters

}
```
```java
public interface TreadmillRepository extends CrudRepository<Treadmill, String> {

}
```
```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class);
    }

    @Component
    public class Runner implements CommandLineRunner {
        private final TreadmillRepository repository;

        public Runner(TreadmillRepository repository) {
            this.repository = repository;
        }

        @Override
        public void run(String... args) {
            // work with the repository here
        }
    }
}
```
**Create**
```java
private void doWeHaveSomethingInDb() {
    long count = repository.count();
    if (count > 0) {
        System.out.printf("Db has %d treadmill(s)%n", count);
    } else {
        System.out.println("Db is empty");
    }
}
```
```java
System.out.println("Before save:");
doWeHaveSomethingInDb();
            
System.out.println("Saving...");
repository.save(new Treadmill("aaa", "Yamaguchi runway"));

System.out.println("After save:");
doWeHaveSomethingInDb();
```
Before save:
Db is empty
Saving...
After save:
Db has 1 treadmill(s)

**Read**
```java
private String createTreadmillView(Treadmill treadmill) {
    return "Treadmill(code: %s, model: %s)"
            .formatted(treadmill.getCode(), treadmill.getModel());
}
```
```java
System.out.println("Looking for the treadmill with code='bbb'... ");
Optional<Treadmill> treadmill = repository.findById("bbb");
String result = treadmill.map(this::createTreadmillView).orElse("Not found");
System.out.println(result);
```
Looking for the treadmill with code='bbb'... 
Treadmill(code: bbb, model: Yamaguchi runway pro-x)
```java
System.out.println("Looking for the treadmill with code='non-existing-code'... ");
Optional<Treadmill> treadmill = repository.findById("non-existing-code");
String result = treadmill.map(this::createTreadmillView).orElse("Not found");
System.out.println(result);
```
Looking for the treadmill with code='non-existing-code'... 
Not found
```java
Iterable<Treadmill> treadmills = repository.findAll();
for (Treadmill treadmill : treadmills) {
    System.out.println(createTreadmillView(treadmill));
}
```
Treadmill(code: aaa, model: Yamaguchi runway)
Treadmill(code: bbb, model: Yamaguchi runway pro-x)
Treadmill(code: ccc, model: Yamaguchi max)

**Update**
```java
Optional<Treadmill> existingTreadmill = repository.findById("aaa");

String existing = existingTreadmill
        .map(this::createTreadmillView)
        .orElse("Not found");

System.out.println("Before update: " + existing);
System.out.println("Updating...");

existingTreadmill.ifPresent(treadmill -> {
    treadmill.setModel("Yamaguchi runway-x");
    repository.save(treadmill);
});

Optional<Treadmill> updatedTreadmill = repository.findById("aaa");
String updated = updatedTreadmill
        .map(this::createTreadmillView)
        .orElse("Not found");

System.out.println("After update: " + updated);
```

Before update: Treadmill(code: aaa, model: Yamaguchi runway)
Updating...
After update: Treadmill(code: aaa, model: Yamaguchi runway-x)

**Delete**
```java
private void printAllTreadmills() {
    Iterable<Treadmill> treadmills = repository.findAll();
    for (Treadmill treadmill : treadmills) {
        System.out.println(createTreadmillView(treadmill));
    }
}
```
```java
System.out.println("Before delete: ");
printAllTreadmills();

System.out.println("Deleting...");
repository.deleteById("ccc");

System.out.println("After delete: ");
printAllTreadmills();
```
Before delete: 
Treadmill(code: aaa, model: yamaguchi runway-x)
Treadmill(code: bbb, model: Yamaguchi runway pro-x)
Treadmill(code: ccc, model: Yamaguchi max)
Deleting...
After delete: 
Treadmill(code: aaa, model: yamaguchi runway-x)
Treadmill(code: bbb, model: Yamaguchi runway pro-x)

```java
System.out.println("Before delete: ");
printAllTreadmills();

System.out.println("Deleting...");
Optional<Treadmill> proXTreadmill = repository.findById("bbb");
proXTreadmill.ifPresent(
        treadmill -> {
            repository.delete(treadmill);
        }
);

System.out.println("After delete: ");
printAllTreadmills();
```
Before delete: 
Treadmill(code: aaa, model: yamaguchi runway-x)
Treadmill(code: bbb, model: Yamaguchi runway pro-x)
Deleting...
After delete: 
Treadmill(code: aaa, model: yamaguchi runway-x)