# We create a class to map a body of an HTTP request to a new instance of an object.
# Post data in JSON format to a path through the body of a POST request.
```java
public class UserInfo {

    private int id;
    private String name;
    private String phone;
    private boolean enabled;

    // getters and setters

    UserInfo() {}
}
```
```java
@RestController
public class UserInfoController {

    @PostMapping("/user")
    public String userStatus(@RequestBody UserInfo user) {
        if (user.isEnabled()) {
            return String.format("Hello! %s. Your account is enabled.", user.getName());

        } else {
            return String.format(
                "Hello! Nice to see you, %s! Your account is disabled",
                user.getName()
            );
        }
    }
}
```

POST localhost:8080/user
Body -> Raw -> JSON
{
    "id":1,
    "name":"asdf",
    "phone":"234343434",
    "enabled":true
}
output
```
Hello! asdf. Your account is enabled.
```

========================================================================================================================================
# posting a list of users to server and the server returns how many users where in the list
```java
@PostMapping("/users")
public String userListStatus(@RequestBody List<UserInfo> userList) {
    return String.format("You gave me a list with %d people in it", userList.size());
}
```
POST localhost:8080/users
Body -> Raw -> JSON
[
{
    "id":1,
    "name":"1asdfasdfa",
    "phone":"234343434",
    "enabled":true
},
{
    "id":2,
    "name":"2asdafsdfas",
    "phone":"234343434",
    "enabled":true
},
{
    "id":3,
    "name":"3asasdfasdfdf",
    "phone":"234343434",
    "enabled":true
}
]
```
You gave me a list with 3 people in it
```

========================================================================================================================================
# Sending data in other formats other than json
https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/MediaType.html

This sends xml instead of json
```java
@RestController
public class UserInfoController {
    
    @PostMapping(value = "/user", consumes = MediaType.APPLICATION_XML_VALUE)
    public String userStatus(@RequestBody UserInfo user) {
        return String.format("Added User %s", user);
    }
}
```

========================================================================================================================================
#We create a class to map a body of an HTTP request to a new instance of an object with getters and setters. 

The phrase "create a class to map a body to an object with getters and setters" in the context of your Spring Boot guide refers to the creation of a Java class that serves as a data transfer object (DTO). This DTO is designed to map (or correspond) to the JSON structure sent in the body of an HTTP request. Let's break down what this means:

1. Data Transfer Object (DTO):
Purpose: A DTO is a simple Java class used to encapsulate data and transfer it between different parts of a program or between different programs, such as in client-server communication.
Mapping to JSON: In the context of a REST API, a DTO typically corresponds to the JSON structure expected in the request body. For example, if the client sends a JSON object with fields like id, name, and phone, the DTO will have corresponding Java fields.
2. Getters and Setters:
Encapsulation: These are methods in the class that allow reading (getters) and modifying (setters) the values of the class's fields. They are a fundamental part of Java's encapsulation principle.
Role in JSON Mapping: These methods are crucial for libraries like Jackson (used in Spring Boot for handling JSON) to serialize and deserialize JSON data. Jackson uses getters to serialize a Java object to JSON and setters to deserialize JSON data to a Java object.
3. Example:
Consider a JSON object that you might send in a POST request:
```json
{
    "id": 123,
    "name": "John Doe",
    "phone": "123-456-7890",
    "enabled": true
}
```

To map this JSON structure in your Spring Boot application, you would create a Java class like this:
```java
Copy code
public class UserInfo {

    private int id;
    private String name;
    private String phone;
    private boolean enabled;

    // Constructor
    UserInfo() {}

    // Getters and setters for each field
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
}
```

4. Usage in a Controller:
When you use the @RequestBody annotation in a controller method, Spring automatically deserializes the JSON data from the request body into an instance of your DTO (e.g., UserInfo), as long as the JSON structure matches the DTO's field structure.

```java
@PostMapping("/user")
public String userStatus(@RequestBody UserInfo user) {
    // Use 'user' object which is now populated with data from the request body
}
```
Conclusion:
Creating a class with fields, getters, and setters to map the JSON body allows Spring Boot to automatically handle the conversion between JSON data in the HTTP request and a Java object in your code. This is a key aspect of building RESTful services with Spring Boot.



===================================================================================================================================================================
# POST handler with both @PathVariable and @RequestBody

Java Class for the Request Body
First, define a Java class for the data you expect in the request body:
```java
public class TaskDetails {
    private String name;
    private String description;

    // Constructors, getters, and setters
}
```


Controller with POST Handler
```java
import org.springframework.web.bind.annotation.*;

@RestController
public class ProjectController {

    @PostMapping("/projects/{projectId}/tasks")
    public String addTaskToProject(@PathVariable("projectId") Long projectId, 
                                   @RequestBody TaskDetails taskDetails) {
        // Logic to add task to the project using projectId and taskDetails
        return String.format("Task '%s' added to project %d", taskDetails.getName(), projectId);
    }
}
```


===================================================================================================================================================================

To make a @RestController available to accept XMLs as the body, one should do the following 3 steps :

1 create a mapping class for the object with setters
2 add @RequestBody before the handling method arguments
3 define the value of "consumes" option for @PostMapping annotation