cascade = CascadeType.ALL

ALL

PERSIST

MERGE

REMOVE

REFRESH

DETACH


Customer class has orders
    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Order> orders = new ArrayList<>();

set cascade = CascadeType.ALL
all operations (persist, remove, merge, etc.) applied to parent entity (Customer) also to child entity (Order)

cascade = CascadeType.REMOVE
vs 
orphanRemoval=true
CascadeType.REMOVE does not automatically handle the situation where a child entity is no longer referenced by its parent but hasn't been explicitly deleted. This is where orphan removal comes into play.

```java
@Service
public class SampleService {

    @Autowired
    EntityManagerFactory entityManagerFactory;

    public void saveCustomer() {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        entityManager.getTransaction().begin();

        Customer cust = new Customer();
        cust.setCustomerName("name");

        Order order = new Order();
        order.setOrderCost(4.52);
        order.setCustomer(cust);

        cust.setOrders(List.of(order));

        entityManager.persist(cust); // look here only persist customer
        entityManager.getTransaction().commit();

    }

}
```

so eventhough only persists customer, order table also goes into database.


When entity first created it is in transient state, persist it to become persistent. 