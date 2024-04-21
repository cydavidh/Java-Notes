package cydavidh.springdemo.p13ntierarchitecture.businesslayer;

import cydavidh.springdemo.p13ntierarchitecture.businesslayer.User;
import cydavidh.springdemo.p13ntierarchitecture.persistence.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User findUserById(Long id) {
        return userRepository.findUserById(id);
    }

    public User save(User toSave) {
        return userRepository.save(toSave);
    }
}