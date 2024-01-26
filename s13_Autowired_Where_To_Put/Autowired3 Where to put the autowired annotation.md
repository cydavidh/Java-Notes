Where to put the @Autowired annotation
You can put the @Autowired annotation in several places worth knowing.

1. As you've seen before, it is possible to put it on top of a constructor:

```Java
@Component
public class Runner implements CommandLineRunner {
    private final PasswordGenerator generator;

    @Autowired
    public Runner(PasswordGenerator generator) {
        this.generator = generator;
    }

    // run
}
```
2. You can place the @Autowired annotation before a constructor argument:

```Java
@Component
public class Runner implements CommandLineRunner {
    private final PasswordGenerator generator;

    public Runner(@Autowired PasswordGenerator generator) {
        this.generator = generator;
    }

    // run
}
```
3. You can place the @Autowired annotation directly on a field to be injected:

```Java
@Component
public class Runner implements CommandLineRunner {

    @Autowired
    private PasswordGenerator generator;

    // run
}
```
4. Alternatively, you can omit the annotation over the constructor. This is possible because Spring IoC knows all the components and can inject them by their type when needed:

```Java
@Component
public class Runner implements CommandLineRunner {
    private final PasswordGenerator generator;

    public Runner(PasswordGenerator generator) {
        this.generator = generator;
    }

    // run
}
```
So, if you don't want to add PasswordGenerator to another component's constructor, you can place @Autowired on the field instead. However, it is recommended to use constructor injection over field injection. Constructor injection identifies the dependencies, helps with thread safety, and simplifies testing the code.

When you use constructor injection, the @Autowired annotation can be omitted, but it is required when you use field injection. Otherwise, your fields will be null. We will continue explicitly using the annotation to make the learning process easier.