Naming Unique PK is fine.
But then you change both PK and FK.

Why not just have FK with descriptive name.
This way no need to configure entity id for ORM to recognize.

# Bidirectional One to one relationship
```java
@Entity
public class User {

    @Id
    private long id;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_details_id")
    private UserDetails userDetails;
}

@Entity
public class UserDetails {

    @Id
    private long id; // Renamed for clarity and consistency

    private String name;
    private String location;
    private String email;

    @OneToOne(mappedBy = "userDetails") //remove for unidirectional
    private User user;
}
```


==================================================================================================================================

# Unidirectional One to many relationship 

```java
@Entity
public class User {

    @Id
    private long id;

    @OneToMany
    @JoinColumn(name = "user_id") // This column will be added to the Tweet table. But we can't use the Tweet entity to get the user_id.

    private List<Tweet> tweets = new ArrayList<>();
}

@Entity
public class Tweet {

    @Id
    private long id;

    // No reference to User entity since unidirectional
}

```


- **Ownership:** In this unidirectional setup, where the `User` entity has the `@OneToMany` relationship annotated with `@JoinColumn(name = "user_id")` but `Tweet` does not reference back to `User`, it might seem like `User` is directing the relationship. However, in terms of JPA and how the database manages this relationship, the foreign key (`user_id`) still resides in the `Tweet` table (as per usual database normalization practices). The **key difference here is in how you perceive ownership**:
    - **Conceptually**, by defining the relationship on the `User` side without a corresponding back-reference in `Tweet`, it might feel like `User` is the "manager" of this relationship.
    - **Physically** (in the database schema), because the `user_id` foreign key is in the `Tweet` table, it aligns with the idea that the "many" side (where the foreign key resides) is technically the owner. **But this traditional notion of ownership is somewhat blurred in unidirectional scenarios without a back-reference.**

- **Bidirectional Relationship:** The `Tweet` entity, having the `@JoinColumn`, is the owner.
- **Unidirectional Relationship (as described):** Conceptually, `User` directs the relationship since it's defined from the `User` side. However, the database schema (which has the `user_id` foreign key in the `Tweet` table) still reflects that the relationship's physical implementation aligns with `Tweet` holding the key to the association. This scenario shows how JPA annotations can influence the perception of ownership and management of relationships, even when underlying database principles remain constant.

==================================================================================================================================



# Bidirectional One to Many / Many to One Relationship

```java
@Entity
public class Tweet {

    @Id
    @Column(name = "tweet_id")
    private long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}

@Entity
public class User {

    @Id
    private long id;

    @OneToMany(mappedBy = "user")
    private List<Tweet> tweets = new ArrayList<>();
}
```