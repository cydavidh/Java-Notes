To find all of the books using Hibernate EntityManager, you typically perform these steps within a Java application. Hibernate EntityManager is part of JPA (Java Persistence API), so the process involves using the `EntityManager` interface to interact with the database. Here’s a simplified example to demonstrate how you could retrieve all books from a database assuming you have a `Book` entity already defined.

### Step 1: Define the Book Entity

First, ensure you have a `Book` entity class annotated with `@Entity`. This class should map to your database table that stores books.

```java
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Book {
    @Id
    private Long id;
    private String title;
    private String author;
    
    // Constructors, getters, and setters
}
```

### Step 2: Setup EntityManager

Ensure you have an `EntityManager` instance. This is usually obtained through an `EntityManagerFactory` that is set up at the application's startup. In a Java EE environment, the `EntityManager` can be injected using `@PersistenceContext`.

```java
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

public class BookRepository {
    @PersistenceContext
    private EntityManager entityManager;
    
    // Methods to interact with the database
}
```

### Step 3: Find All Books

To find all books, you use the `EntityManager` to create a `TypedQuery` and execute a JPQL (Java Persistence Query Language) query.

```java
import javax.persistence.TypedQuery;
import java.util.List;

public class BookRepository {
    @PersistenceContext
    private EntityManager entityManager;
    
    public List<Book> findAllBooks() {
        TypedQuery<Book> query = entityManager.createQuery("SELECT b FROM Book b", Book.class);
        return query.getResultList();
    }
}
```

This `findAllBooks` method creates a JPQL query that selects all entities of type `Book` from the database. The `getResultList` method executes the query and returns a list of `Book` instances that are found in the database.

### Complete Example

Putting it all together, the `BookRepository` class would look something like this:

```java
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

public class BookRepository {
    
    @PersistenceContext
    private EntityManager entityManager;
    
    public List<Book> findAllBooks() {
        TypedQuery<Book> query = entityManager.createQuery("SELECT b FROM Book b", Book.class);
        return query.getResultList();
    }
}
```

### Running the Method

To use the `findAllBooks` method, you would typically call it from your application code, such as a service layer or directly from a UI controller, depending on your application's architecture.

Remember, this example assumes you have set up JPA correctly in your project, including the persistence.xml configuration file (or equivalent if using Spring Boot or similar frameworks) and have the necessary dependencies in your project.