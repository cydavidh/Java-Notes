package cydavidh.springdemo.cascade;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

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

        entityManager.persist(cust);
        entityManager.getTransaction().commit();

    }

}
