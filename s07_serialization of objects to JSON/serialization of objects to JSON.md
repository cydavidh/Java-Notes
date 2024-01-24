# Jackson Library serializes object to JSON automatically for you
By default, Jackson serializes all properties with a public getter method and deserializes from all properties with a public setter method.
serialize into json, deserialize from json to object.
```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoController {

    @GetMapping("/person")
    public Person getPerson() {
        return new Person("John", "Doe", 25);
    }

    public class Person {
        private String firstName;
        private String lastName;
        private int age;

        // Constructors, getters and setters are omitted for brevity
    }

    @GetMapping("/people")
    public List<Person> getPeople() {
        return Arrays.asList(
            new Person("John", "Doe", 25),
            new Person("Jane", "Doe", 24)
        );
    }
}


```
GET localhost:8080/person
```
{
  "firstName": "John",
  "lastName": "Doe",
  "age": 25
}
```


=============================================================================================================================================================
# Nested Object

```java
public class Address {
    private String street;
    private String city;
    private String country;

    // Constructors, getters and setters are omitted for brevity
}

public class Person {
    private String firstName;
    private String lastName;
    private int age;
    private Address address;

    // Constructors, getters and setters are omitted for brevity
}
```

```java
Person person = new Person("John", "Doe", 25, new Address("Olesvej", "Qaqortoq", "Greenland"))
```

```
{
  "firstName": "John",
  "lastName": "Doe",
  "age": 25,
  "address": {
    "street": "Olesvej",
    "city": "Qaqortoq",
    "country": "Greenland"
  }
}
```

=============================================================================================================================================================
# Circular references
For example, consider two classes, Parent and Child, where a Parent object contains a list of Child objects, and each Child object has a reference back to the Parent object.

```java
public class Parent {
    private String name;
    
    @JsonManagedReference
    private List<Child> children;

    // Constructors, getters and setters are omitted for brevity
}

public class Child {
    private String name;

    @JsonBackReference
    private Parent parent;

    // Constructors, getters and setters are omitted for brevity
}
```

```
{
  "name": "parent",
  "children": [
    {
      "name": "child 1"
    },
    {
      "name": "child 2"
    }
  ]
}
```

=============================================================================================================================================================


# @JsonIgnore

```java
public class Person {
    private String firstName;
    private String lastName;

    @JsonIgnore
    private String password;

    // methods omitted for brevity

}
```

```
{
  "firstName": "John",
  "lastName": "Doe"
}
```

=============================================================================================================================================================


# change property name with @JsonProperty

```java
public class Person {
    @JsonProperty("first_name")
    private String firstName;

    @JsonProperty("last_name")
    private String lastName;

    private int age;

    // Constructors, getters and setters are omitted for brevity
}
```