package cydavidh.springdemo.beanvalidation;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SpecialAgentController {
    @PostMapping("/agent")
    public ResponseEntity<String> validate(@Valid
                                           @RequestBody
                                           SpecialAgent agent) {
        return ResponseEntity.ok("Agent authorized");
    }
}
