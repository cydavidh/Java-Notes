### Bean Lifecycle Customization in Spring

#### **1. Using Annotations (@PostConstruct and @PreDestroy)**

- **Java Example:**

    ```java
    @Component
    class TechLibrary {
        private final List<String> bookTitles = Collections.synchronizedList(new ArrayList<>());
    
        @PostConstruct
        public void init() {
            bookTitles.add("Clean Code");
            bookTitles.add("The Art of Computer Programming");
            bookTitles.add("Introduction to Algorithms");
            System.out.println("The library has been initialized: " + bookTitles);
        }
    
        @PreDestroy
        public void destroy() {
            bookTitles.clear();
            System.out.println("The library has been cleaned: " + bookTitles);
        }
    }
    ```

#### **2. Using @Bean Annotation with initMethod and destroyMethod**

- **Java Example:**

    ```java
    @Configuration
    class Config {
        @Bean(initMethod = "init", destroyMethod = "destroy")
        public TechLibrary library() {
            return new TechLibrary();
        }
    }
    
    class TechLibrary {
        private final List<String> bookTitles = Collections.synchronizedList(new ArrayList<>());
    
        public void init() {
            bookTitles.add("Clean Code");
            bookTitles.add("The Art of Computer Programming");
            bookTitles.add("Introduction to Algorithms");
            System.out.println("The library has been initialized: " + bookTitles);
        }
    
        public void destroy() {
            bookTitles.clear();
            System.out.println("The library has been cleaned: " + bookTitles);
        }
    }
    ```

#### **3. Using Interfaces (InitializingBean and DisposableBean)**

- **Java Example:**

    ```java
    @Component
    class TechLibrary implements InitializingBean, DisposableBean {
        private final List<String> bookTitles = Collections.synchronizedList(new ArrayList<>());
    
        @Override
        public void afterPropertiesSet() throws Exception {
            bookTitles.add("Clean Code");
            bookTitles.add("The Art of Computer Programming");
            bookTitles.add("Introduction to Algorithms");
            System.out.println("The library has been initialized: " + bookTitles);
        }
    
        @Override
        public void destroy() {
            bookTitles.clear();
            System.out.println("The library has been cleaned: " + bookTitles);
        }
    }
    ```

#### **4. Using BeanPostProcessor for Custom Operations**

- **Java Example:**

    ```java
    @Component
    class PostProcessor implements BeanPostProcessor {
    
        @Override
        public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
            System.out.println("Before initialization: " + beanName);
            return BeanPostProcessor.super.postProcessBeforeInitialization(bean, beanName);
        }
    
        @Override
        public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
            System.out.println("After initialization: " + beanName);
            return BeanPostProcessor.super.postProcessAfterInitialization(bean, beanName);
        }
    }
    ```

using th
```java
@Configuration
class Config {

    @Bean
    public MovieStorage storage() {
        return new MovieStorage();
    }
}

class MovieStorage {
    private final List<String> movies = Collections.synchronizedList(new ArrayList<>());

    @PostConstruct
    public void init() {
        // initialize movies
    }

    @PreDestroy
    public void destroy() {
        // cleanup movies
    }
}
```


Initialization in the context of Spring's bean lifecycle refers to a phase that occurs after a bean has been instantiated and had its dependencies injected, but before the bean is put into use by the application. This phase is crucial for setting up a bean's internal state, validating its properties, or starting up some processes necessary for the bean to function correctly in the application. Here's a closer look at what happens during the initialization phase:

1. **Bean Instantiation**: Spring creates an instance of the bean. This is often done by invoking the bean's constructor, but can also involve factory methods or other mechanisms.

2. **Dependency Injection**: After the bean instance is created, Spring injects dependencies defined in the application context into the bean. These dependencies are typically other beans managed by Spring and are set via constructor arguments, setter methods, or fields directly.

3. **Initialization**: Once all required dependencies have been injected into the bean, the initialization phase can begin. During this phase, custom initialization logic can be executed to prepare the bean for use. Spring provides several ways to specify initialization behavior:
   - Implementing the `InitializingBean` interface and overriding the `afterPropertiesSet` method.
   - Defining a method annotated with `@PostConstruct`.
   - Specifying a custom init-method in the bean definition.

The initialization phase is designed to allow beans to perform any required setup, such as opening resources (e.g., database connections), validating configurations, or starting background processes. This phase ensures that the bean is fully configured and ready to handle requests or tasks in the application.

After initialization, the bean is ready to be used by the application, and it remains in the application context until the application shuts down or the bean is explicitly removed. At the end of the bean's lifecycle, a corresponding cleanup phase can occur, where resources can be released or shutdown processes executed, typically through the `@PreDestroy` annotation, implementing the `DisposableBean` interface, or specifying a custom destroy-method in the bean definition.