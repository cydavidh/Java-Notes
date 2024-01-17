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
PathVariable

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
By default, a method annotated with @GetMapping returns a response with the status code 200 OK if a request was processed successfully and the status code 500 if there is an uncaught exception. However, we can change this default status code by returning an object of the ResponseEntity<T> class.
```java
@GetMapping("/tasks/{id}")
public ResponseEntity<Task> getTasks(@PathVariable int id) {
    return new ResponseEntity<>(taskList.get(id - 1), HttpStatus.ACCEPTED);
}
```