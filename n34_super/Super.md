# Superclass

```java
public class Person {
    private String name;
    private String address;
    private String phone;

    public Person(String name, String address) {
        this.name = name;
        this.address = address;
    }

    public void addPhone(int phone) {
        this.phone = phone;
    }

}
```

# Subclass

```java
public class Student extends Person {
    private int credits;

    public Student(String name, String address, int phone) {
        super(name, address);
        super.addPhone(phone); // remember super.method(), too!
    }

}
```

A subclass sees everything that is defined with the "public" modifier in the superclass. If we want to define some variables or methods that are visible to the subclasses but invisible to everything else, we can use the access modifier "protected" to achieve this.