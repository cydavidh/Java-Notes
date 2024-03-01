put in build.gradle: 
implementation 'org.springframework.boot:spring-boot-starter-validation'

@Valid checks @RequestBody to see if each field matchs the java object fields.


request body
{
    "name": "James",
    "surname": "Bond",
    "code": "007",
    "status": "special agent",
    "age": 51
}

java class
```java
public class SpecialAgent {
    @NotNull
    private String name;
    @NotEmpty(message = "not empty bro") //not null nor empty
    private String surname;
    @Size(min = 1, max = 3)
    @Pattern(regexp = "[0-9]{1,3}")
    private String code;
    @NotBlank //not null and must contain at least one non-whitespace character.
    private String status;
    @Min(value = 18, message = "Age must be greater than or equal to 18")
    private int age;

    //getters and setters
}
```
this is how you use @Valid in controller
```java
@RestController
public class SpecialAgentController {
    @PostMapping("/agent")
    public ResponseEntity<String> validate(@Valid
                                           @RequestBody
                                           SpecialAgent agent) {
        return ResponseEntity.ok("Agent authorized");
    }
}
```
handle exception if no match
```java
@ControllerAdvice
public class ValidationExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Object> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach((error) -> {
            String fieldName = error.getField();
            String errorMessage = error.getDefaultMessage();
//            errors.put(fieldName, errorMessage);
            errors.put("defaultMessage", errorMessage);
        });
        return ResponseEntity.badRequest().body(errors);
    }
}
```
================================================================================================================================================================

@Validated checks @RequestParameter @PathVariable
```java
@RestController
@Validated
public class SpecialAgentController {

    @GetMapping("/agents/{id}")
    ResponseEntity<String> validateAgentPathVariable(@PathVariable("id") @Min(1) int id) {
        return ResponseEntity.ok("Agent id is valid.");
    }

    @GetMapping("/agents")
    ResponseEntity<String> validateAgentRequestParam(
            @RequestParam("code") @Pattern(regexp = "[0-9]{1,3}") String code) {
        return ResponseEntity.ok("Agent code is valid.");
    }
}
```

also works on a list of objects
```java
@RestController
@Validated
public class SpecialAgentController {

    @PostMapping("/agent")
    public ResponseEntity<String> validate(@RequestBody List<@Valid SpecialAgent> agents) {
        return ResponseEntity.ok("All agents have valid info.");
    }
}
```