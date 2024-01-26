```java
@Component
public class Runner implements CommandLineRunner {

    @Override
    public void run(String... args) {
        System.out.println("Hello, Spring!");
    }
}
```

Yes, using CommandLineRunner in a Spring application serves as a means to execute code after the Spring context has been fully initialized but before the application starts running. It's useful for running logic right at the start, like initializing data, running a quick piece of code for debugging, or triggering batch jobs.

It's different from putting a println in the main method because the main method executes before the Spring context is set up. Any println in main wouldn't have access to Spring-managed beans or the full capabilities of the Spring framework. CommandLineRunner ensures that the entire application context, including all beans and configurations, is loaded and ready before its run method is executed. This makes it suitable for operations that require the full application setup.