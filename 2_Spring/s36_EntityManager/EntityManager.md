```java
@Entity 
@Table(name = "users")
public class User {

    @Id 
    private Long id;
    private String name;
    private String email;

    public User() {}

    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }

    // getters and setters
}
```

### Use `EntityManager` CRUD Operations
has methods like persist, remove, merge, find

Spring Data JPA -> Repository is based on EntityManager
has methods like save, findById, findAll, deleteById, etc.

#### Create

```java
EntityManager em = emFactory.createEntityManager();
em.getTransaction().begin();

User newUser = new User("John Doe", "john.doe@example.com");
em.persist(newUser); // This will insert a new row into the user table.

em.getTransaction().commit();
em.close();
```

#### Read/Find/Get

```java
EntityManager em = emFactory.createEntityManager();

User user = em.find(User.class, userId); // Retrieve the user with the specified ID.

em.close();
```

#### Update

```java
EntityManager em = emFactory.createEntityManager();
em.getTransaction().begin();

User user = em.find(User.class, userId);
user.setEmail("new.email@example.com"); // Update the email of the user.
em.merge(user); // Apply the changes to the database.

em.getTransaction().commit();
em.close();
```

#### Delete

```java
EntityManager em = emFactory.createEntityManager();
em.getTransaction().begin();

User user = em.find(User.class, userId);
em.remove(user); // Delete the user from the database.

em.getTransaction().commit();
em.close();
```