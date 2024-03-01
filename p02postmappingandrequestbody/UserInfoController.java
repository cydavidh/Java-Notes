package cydavidh.springdemo.p02postmappingandrequestbody;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class UserInfoController {
    @PostMapping("/auser")
    public String userStatus(@RequestBody UserInfo user) {
        if (user.isEnabled()) {
            return String.format("Hello! %s. Your account is enabled.", user.getName());
        } else {
            return String.format("Hello! Nice to see you, %s! Your account is disabled", user.getName());
        }
    }

    @PostMapping(value = "/ausers")
    public String userListStatus(@RequestBody List<UserInfo> userList) {
        return String.format("You gave me a list with %d people in it", userList.size());
    }


}
