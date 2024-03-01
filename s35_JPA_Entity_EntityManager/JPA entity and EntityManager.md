```java
@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_id")
    private long orderId;

    @Column(name = "product_type")
    private String productType;

    @Temporal(TemporalType.DATE)
    @Column(name = "order_date")
    private Date orderDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_status")
    private Status orderStatus;

    @Transient
    private String orderProgress;

    public Order() {}

}
```
=============================================================================================================================================================

### Example Entity Definition

```java
@Entity // This annotation specifies that the class is an entity.
public class User {

    @Id // This annotation specifies the primary key of the entity.
    @GeneratedValue(strategy = GenerationType.IDENTITY) // This annotation defines the primary key generation strategy.
    private Long id;

    private String name;
    private String email;

    // Constructors, getters, and setters
    public User() {}

    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }

    // standard getters and setters
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

#### Read

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