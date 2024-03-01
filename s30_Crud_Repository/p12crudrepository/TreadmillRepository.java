package cydavidh.springdemo.p12crudrepository;

import org.springframework.data.repository.CrudRepository;

public interface TreadmillRepository extends CrudRepository<Treadmill, String> {
    // The CrudRepository interface already provides basic CRUD operations
    // No need to add any methods here for now
}
