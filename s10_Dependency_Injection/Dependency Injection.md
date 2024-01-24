# Why DI?
DI because it makes the system more modular.
# What is DI?
DI is like giving your class everything it needs instead of making it find or create those things itself. 

Imagine a car that doesn't have to build its own engine but instead gets an engine handed to it ready to go. This makes it easier to swap out parts, test each part separately, and change how things work without redoing the whole car.

=====================================================================================
1. The `User` class directly creates a new instance of `MySqlDatabase`, leading to tight coupling between the `User` and `MySqlDatabase`.
```java
public class User {
    MySqlDatabase database;

    public User() {
        this.database = new MySqlDatabase();
    }

    public void add(String data) {
        database.persist(data);
    }
}
```

2. The `User` class now receives a `MySqlDatabase` object through its constructor, reducing coupling but still relying on a specific database implementation.
```java
public class User {
    MySqlDatabase database;

    public User(MySqlDatabase database) {
        this.database = database;
    }

    public void add(String data) {
        database.persist(data);
    }
}
```

3. The `User` class is modified to use a `Database` interface, allowing for flexible dependency injection with different database implementations, achieving true dependency injection.
```java
 public class User{
    Database database;

    public User(Database database) {
        this.databse = database;
    }

    public void add(String data) {
        database.persist(data);
    }
 }
```

4. So now when you use the User
```java
public class Program {
    public static void main(String[] args) {
        Database database = new MySqlDatabase();
        User user = new User(database);
    }
}
```

=====================================================================================
# Ways to implement DI

The Dependency class that examples below will be injecting.
```java
public class Dependency {
    private String data;

    public Dependency() {
        // Constructor logic
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public void performTask() {
        // Some functionality that MyService depends on
    }
}
```

Constructor Injection: Dependencies are provided through a class constructor. Just do this bro seriously
```java
public class MyService {
    private final Dependency dependency;

    public MyService(Dependency dependency) {
        this.dependency = dependency;
    }
}
```

Setter Injection: Dependencies are provided through setter methods.
```java
public class MyService {
    private Dependency dependency;

    public void setDependency(Dependency dependency) {
        this.dependency = dependency;
    }
}
```

Method (Interface) Injection: Dependency is provided through a method other than a setter.
```java
public interface DependencyInjector {
    void injectDependency(Dependency dependency);
}

public class MyService implements DependencyInjector {
    private Dependency dependency;

    @Override
    public void injectDependency(Dependency dependency) {
        this.dependency = dependency;
    }
}
``` 

Field Injection: Dependencies are injected directly into fields, usually with annotations (like @Autowired in Spring). Not possible in standard Java.
```java
public class MyService {
    @Autowired
    private Dependency dependency;
}
```

=====================================================================================
# Example of cases where method injection might be better than setter injection
```java
public interface ServiceInitializer {
    void initializeServices(DatabaseService dbService, LoggingService logService);
}

public class ClientService implements ServiceInitializer {
    private DatabaseService databaseService;
    private LoggingService loggingService;

    @Override
    public void initializeServices(DatabaseService dbService, LoggingService logService) {
        this.databaseService = dbService;
        this.loggingService = logService;
        // Additional initialization logic using both services
        this.databaseService.setupConnection();
        this.loggingService.setupLogger();
    }
}
```
In this code, `ClientService` implements `ServiceInitializer`, which defines the `initializeServices` method. This method injects two different services: `DatabaseService` and `LoggingService`. It allows `ClientService` to perform initialization logic that relies on both services being present, which is a scenario where method injection offers more flexibility and control compared to individual setter methods for each service.
