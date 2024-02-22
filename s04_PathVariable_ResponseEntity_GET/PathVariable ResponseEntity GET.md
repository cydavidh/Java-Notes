# get /test
```java
@RestController
public class TaskController {

    @GetMapping("/test")
    public int returnOne() {
        return 1;
    }
}
```

GET http://localhost:8080/test
returns:
1
=============================================================================================================================================
# Get list of tasks

```java
@RestController
public class TaskController {
    private final List<Task> taskList = List.of(
            new Task(1, "task1", "A first test task", false),
            new Task(2, "task2", "A second test task", true)
    );

    @GetMapping("/tasks")
    public List<Task> getTasks() {
        return taskList;
    }
}
```
GET http://localhost:8080/tasks
```
[
    {
        "id": 1,
        "name": "task1",
        "description": "A first test task",
        "completed": false
    },
    {
        "id": 2,
        "name": "task2",
        "description": "A second test task",
        "completed": true
    }
]
```
=============================================================================================================================================
# PathVariable

```java

@RestController
public class TaskController {
    private final List<Task> taskList = List.of(
        new Task(1, "task1", "A first test task", false),
        new Task(2, "task2", "A second test task", true)
    );

    @GetMapping("/tasks/{id}")
    public Task getTask(@PathVariable int id) {
        return taskList.get(id - 1); // list indices start from 0
    }
}
```

```
{
    "id": 2,
    "name": "task2",
    "description": "A second test task",
    "completed": true
}
```

=============================================================================================================================================
# return http status code for the GET
By default, a method annotated with @GetMapping returns a response with the status code 200 OK if a request was processed successfully and the status code 500 if there is an uncaught exception. However, we can change this default status code by returning an object of the ResponseEntity<T> class.

```java
@GetMapping("/tasks/{id}")
public ResponseEntity<Task> getTasks(@PathVariable int id) {
    return new ResponseEntity<>(taskList.get(id - 1), HttpStatus.ACCEPTED);
}
```

=============================================================================================================================================
# two ways to return ResponseEntity: both return new instance, one with constructor, another with methods.

https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/ResponseEntity.html#field-summary
https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/ResponseEntity.BodyBuilder.html

```java
@RestController
public class ApiController {
    @GetMapping("/api/health")
    public ResponseEntity<String> health() {
        return new ResponseEntity<>("OK", HttpStatus.OK); // returns a new instance (with a body of String "OK") by using the ResponseEntity constructor
    }

    @GetMapping("/api/qrcode")
    // return 501 Not Implemented
    public ResponseEntity<String> qrcode() {
        return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).body("Not Implemented"); 
        // uses ResponseEntity.status() to create a BodyBuilder instance and then calls body() to create the ResponseEntity instance
        /*The method call ResponseEntity.status(501) creates an instance of ResponseEntity.BodyBuilder. 
        This BodyBuilder is then used to set up various parts of the response entity. 
        When the .body("Not Implemented") method is called on this BodyBuilder, 
        it completes the building process and creates an instance of ResponseEntity<String> with the specified status and body. */
    }
}

```