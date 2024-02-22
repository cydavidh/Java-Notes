Let's simplify the guide to understanding Spring's core concept and how to use it in your projects.

### Spring's Main Idea: IoC Container

Spring Framework has a special feature called the IoC (Inversion of Control) container. It's like a big box that manages the creation and assembly of your objects, known as beans. The IoC container makes sure each object gets the necessary components (dependencies) it needs to work properly.

### Setting Up Your Project

#### Step 1: Create a Person Class
First, you need a simple class to work with. Let's use a `Person` class as an example:

```java
public class Person {
   private String name;

   public Person(String name) {
       this.name = name;
   }
}
```

#### Step 2: Tell Spring About Your Beans
Next, we need a way to tell Spring which objects to manage. We do this in a configuration class:

```java
@Configuration
public class Config {
    @Bean
    public Person personMary() {
        return new Person("Mary");
    }
}
```
This configuration class says, "Hey Spring, please create a `Person` object named Mary and keep it ready for use."

#### Step 3: Create an Application Context
The application context is where Spring keeps all your beans. To set it up, you use:

```java
public class Application {
    public static void main(String[] args) {
        var context = new AnnotationConfigApplicationContext(Config.class);
        System.out.println(Arrays.toString(context.getBeanDefinitionNames()));
    }
}
```
This code snippet creates a context that knows about your `Person` bean and a configuration bean.

#### Step 4: Accessing Your Beans
You can get your beans from the context in different ways, such as by type or by name. For example:

- `context.getBean(Person.class);` gets the `Person` object.
- `context.getBean("personMary");` gets the `Person` object named Mary.

### Advanced: Scanning for Components

Instead of manually defining each bean, you can tell Spring to automatically find them using `@ComponentScan` and `@Component` annotations. This is useful for larger projects:

```java
@Component
public class Book {
}

@Component
public class Movie {
}
```
And in your configuration class, you add `@ComponentScan` to tell Spring to look for these annotated classes:

```java
@ComponentScan
@Configuration
public class Config {
    // Your bean definitions
}
```

### Spring Boot: Simplifying Configuration

In Spring Boot, much of this setup is automated. You use `@SpringBootApplication` to kick things off:

```java
@SpringBootApplication
public class Application {
  public static void main(String[] args) {
     SpringApplication.run(Application.class, args);
  }
}
```
Spring Boot automatically creates the application context and scans for components, making your configuration much simpler.

### Conclusion

We've seen how Spring's IoC container helps manage your objects and dependencies, making it easier to develop large applications. By defining beans, creating an application context, and using Spring Boot, you can streamline your development process significantly.