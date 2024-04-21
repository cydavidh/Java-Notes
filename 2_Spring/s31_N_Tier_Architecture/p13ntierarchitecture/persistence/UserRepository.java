package cydavidh.springdemo.p13ntierarchitecture.persistence;

import cydavidh.springdemo.p13ntierarchitecture.businesslayer.User;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends CrudRepository<User, Long> {
    User findUserById(Long id);
}