
```java
@Configuration
public class PasswordConfig {
    private static final String ALPHA = "abcdefghijklmnopqrstuvwxyz";
    private static final String NUMERIC = "0123456789";
    private static final String SPECIAL_CHARS = "!@#$%^&*_=+-/";

    @Bean
    public PasswordAlphabet allCharacters() {
        return new PasswordAlphabet(ALPHA + NUMERIC + SPECIAL_CHARS);
    }

    static class PasswordAlphabet { // Should be a seperate class (domain object) of its own according to Single Responsibility Principle
        private final String characters;

        public PasswordAlphabet(String characters) {
            this.characters = characters;
        }

        public String getCharacters() {
            return characters;
        }
    }
}
```

```java
@Component
public class PasswordGenerator {
    private static final Random random = new Random();
    private final PasswordAlphabet alphabet;

    public PasswordGenerator(@Autowired PasswordAlphabet alphabet) { //inject the PasswordAlphabet here
        this.alphabet = alphabet;
    }

    public String generate(int length) {
        String allCharacters = alphabet.getCharacters(); // get the characters from the bean
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(allCharacters.length());
            result.append(allCharacters.charAt(index));
        }

        return result.toString();
    }
}
```

```java
@Component
public class Runner implements CommandLineRunner {
    private final PasswordGenerator generator;

    @Autowired
    public Runner(PasswordGenerator generator) { //inject the PasswordGenerator here
        this.generator = generator;
    }

    @Override
    public void run(String... args) {
        System.out.println("A short password: " + generator.generate(5));
        System.out.println("A long password: " + generator.generate(10));
    }
}
```

output 
```
A short password: e&7sd
A long password: up_&g4xtj7
```

=====================================================================================================================================


# @Component vs @Bean

So far, we have used the @Bean and @Componentgeneric annotation to create beans that can be injected into each other. Now let's look at the differences between these annotations in Spring Framework.

- The @Bean annotation is a method-level annotation, whereas @Component is a class-level annotation.

- The @Component annotation doesn't need to be used with the @Configuration annotation, whereas the @Beangeneric annotation has to be used within a class annotated with @Configuration.

- If you want to create a single bean for a class from an external library, you cannot just add the @Componentannotation because you cannot edit the class. However, you can define a @Configuration class and then declare a method annotated with @Bean and return an object of this class from this method.

- There are several specializations of the @Component annotation, whereas @Bean doesn't have any specialized stereotype annotations.

In most cases, you can use both approaches, but **Spring developers typically prefer Spring @Component annotation whenever possible. The @Bean annotation is mainly used for producing beans of unmodifiable classes or creating configs**.


