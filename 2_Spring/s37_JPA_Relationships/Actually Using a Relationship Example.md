```java
@Entity
public class OrderItem {
    @ManyToOne
    private Order order; // Defines a Many-to-One relationship with the Order entity. This annotation indicates that multiple OrderItem entities can be associated with a single Order entity.
}

// Example usage:

Order o = em.find(Order.class, 1L); // Finds an Order entity with ID = 1 (of type Long) in the database. This step retrieves an existing Order based on its primary key using the EntityManager's find method.

OrderItem i = new OrderItem(); // Creates a new instance of OrderItem. This new object is initialized in the Java application's memory but not yet persisted in the database.

i.setOrder(o); // Sets the retrieved Order instance 'o' as the associated Order for this OrderItem. This line establishes the association between the newly created OrderItem instance and the retrieved Order instance, effectively setting up the many-to-one relationship.

em.persist(i); // Saves the new OrderItem, along with its association to Order 'o', to the database. The persist method inserts the new OrderItem into the database, and the foreign key column in the OrderItem table will reference the ID of the associated Order entity.
```