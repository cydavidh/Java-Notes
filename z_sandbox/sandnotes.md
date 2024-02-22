Spring provides several annotations to declare container-managed objects named beans. They are created once and injected automatically into all target places of your application. So far, you have relied only on default container settings to work with beans, but there is much more room for their customization. One of the things you can customize is the scope of beans, which defines the whole lifecycle of a bean: when it is created, injected, and deleted. In this topic, you will learn about various scopes, allowing you to work more flexibly with beans.

Setting up the scope of a bean
As you already know, Spring beans are singletons by default. This means beans are created once and then reused wherever possible. As a result, you will have multiple references to the same bean. However, the singleton scope is just one of many possible bean scopes.

Spring supports six bean scopes: singleton, prototype, request, session, application, and websocket. The first two scopes can be used in any Spring application, including console-based ones, while the other four are only available in web applications and rely on HTTP-based concepts such as HTTP requests, sessions, etc. In this topic, we'll discuss the singleton and prototype scopes in detail and then provide some basic information about the four other scopes to keep all related concepts together.

To set up a scope, you should use the @Scope annotation. This annotation accepts the scope name as its value and allows you to define the scope of a bean when it is declared. The @Scope annotation can be applied to both @Bean-annotated method and @Component-annotated classes. We'll see how it works in a moment.

A template for future examples
To explain the idea of scopes, we will declare a simple bean for counting integer numbers in the AppConfig class.


@Configuration
public class AppConfig {

    @Bean
    public AtomicInteger createCounter() {
        return new AtomicInteger();
    }
}

Another component of the app will be the AppRunner class, which is used to start the app as a standard console application.


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

Note that the class has two fields that are both counters. The run method increments the counters and then prints their values. Depending on the configured scope of the counter bean, we will see different results with this code.

Singleton scope
As we have mentioned, Spring beans have a singleton scope by default. This scope is exceptionally useful in typical applications. With it, the container creates only one instance of a bean for the whole ApplicationContext and injects it into other beans when expected.

The singleton scope can also be specified explicitly by putting the @Scope annotation with the string value "singleton" above bean declarations.


@Bean
@Scope("singleton")
public AtomicInteger createCounter() { /* ... */ }

As an alternative to the string literal, you can use the predefined constant from the ConfigurableBeanFactory class.

@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
Since the @Scope annotation is optional for singleton beans, you should decide whether to write it according to the conventions used in your project and team.

If we start the Spring Boot application containing the above classes, we will see the following output:

10
10
Both lines are identical because counter1 and counter2 refer to the same singleton bean.

Prototype scope
In some cases, we don't want to use the same bean in different parts of an application. To turn a bean into a non-singleton, we can use the prototype scope. When we use it, the container returns a new bean every time it should be injected into a target. To define a bean with this scope, we should use the @Scope annotation with the string value "prototype".


@Bean
@Scope("prototype")
public AtomicInteger createCounter() { /* ... */ }

There is also a convenient predefined constant in the ConfigurableBeanFactory class.

@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
To demonstrate the idea of the prototype scope in practice, let's look at our example again. If we change the scope of the counter bean to prototype, we will get another result:

7
3
This result means the counter1 and counter2 fields refer to different beans with independent states.

When a singleton-scoped bean depends on a prototype-scoped bean, a new prototype-scoped bean is created only once, namely, when the singleton bean is instantiated.

Injecting a prototype-scoped bean into another prototype-scoped bean or injecting a singleton into a prototype-scoped bean is also allowed.

Other bean scopes
In addition to the previous two scopes, there are four other scopes that are only available in web applications:

The request scope allows a bean to be created for the whole lifecycle of an HTTP request. If a request is processed by several Spring components, the request-scoped bean will be available in all these components.

The session scope allows a bean to be created for the whole HTTP session, including sequences of HTTP requests connected by cookies or a session ID.

The application scope allows a bean to be created for several applications (ApplicationContext) running in the same ServletContext. This scope is broader than the singleton scope, which is only scoped to a single application context.

The websocket scope allows a bean to be created for the complete lifecycle of a WebSocket session.

To use any of these scopes, you must pass its name to the @Scope annotation, e.g., @Scope("request"). There are also several annotations, like @RequestScope, @SessionScope, and @ApplicationScope, which are shortcuts for @Scope with a corresponding value. You can use these annotations only if your application depends on the spring-web module.

Conclusion
In this topic, you've explored the idea of bean scopes, which allow configuring when beans are created and injected. We demonstrated how to use the @Scope annotation and showed the difference between singleton and prototype-scoped beans, which can be used in any Spring application. We also mentioned the four other scopes (request, session, application, and websocket) specific to web applications. You don't have to remember all of them right now. It is enough to get the main idea and continue studying these scopes in web-related topics.