Superclass

```java
public class Person {
    private String name;
    private String address;

    public Person(String name, String address) {}

    @Override
    public String toString() {}
}
```

Output: 
Ada Lovelace, 24 Maddox St. London W1S 2QN

```java
public class Student extends Person {
    private int credits;

    public Student(String name, String address) {
        super(name, address);
        this.credits = 0;
    }

    public int credits() {return this.credits;}

//If a method or variable has the access modifier private, it is visible only to the internal methods of that class. Subclasses will not see it, and a subclass has no direct means to access it. 

    @Override
    public String toString() {
        //super.name: The field Person.name is not visible
        return super.toString() + this.credits;
    }
}
```
Output:
Ollie, 6381 Hollywood Blvd. Los Angeles 90028, Study credits 0


A subclass sees everything that is defined with the "public" modifier in the superclass. If we want to define some variables or methods that are visible to the subclasses but invisible to everything else, we can use the access modifier "protected" to achieve this.