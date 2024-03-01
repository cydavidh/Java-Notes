package cydavidh.springdemo.p13ntierarchitecture.presentation;

import cydavidh.springdemo.p13ntierarchitecture.businesslayer.User;
import cydavidh.springdemo.p13ntierarchitecture.businesslayer.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {
    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }
    @PostMapping("/user")
    public User saveUser(@RequestBody User user) {
        User createdUser = userService.save(new User(
                user.getId(), user.getUsername(),
                user.getFirstName(), user.getLastName()));

        return createdUser;
    }

    @GetMapping("/user/{id}")
    public User getUser(@PathVariable long id) {
        return userService.findUserById(id);
    }
}