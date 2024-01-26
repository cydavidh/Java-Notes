# Superclass

```java
public class Person {
    protected String name;
    protected String address;
    protected String phone;

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
        super.name = name;
        this.address = address; // super is optional if different field names
    }

}
```

A subclass sees everything that is defined with the "public" modifier in the superclass. If we want to define some variables or methods that are visible to the subclasses but invisible to everything else, we can use the access modifier "protected" to achieve this.














=====================================================================================================================================================
Sample Input 1:

```
Dog
```
Sample Output 1:

```
Name: Rusty
Sound: Bark
```

```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        // Step 1: Create the superclass 'Animal'
        class Animal {
            protected String name;

            // constructor to initialize 'name'
            public Animal() {
                this.name = new String();
            }

            public Animal(String name) {
                this.name = name;
            }

            // getter for 'name'
            public String getName() {
                return this.name;
            }

            // setter for 'name'
            public void setName(String name) {
                this.name = name;
            }
        }

        // Step 2: Create the subclass 'Dog' that inherits from 'Animal'
        class Dog extends Animal {
            protected String sound;

            public Dog(String name, String sound) {
                super.name = name;
                this.sound = sound;
            }

            public String getSound() {
                return this.sound;
            }

            public void setSound(String sound) {
                this.sound = sound;
            }
        }

        // Step 3: Create the subclass 'Bird' that inherits from 'Animal'
        class Bird extends Animal {
            protected boolean canFly;

            public Bird(String name, boolean canFly) {
                super.setName(name);
                this.canFly = canFly;
            }

            public boolean getCanFly() {
                return this.canFly;
            }

            public void setCanFly(boolean canFly) {
                this.canFly = canFly;
            }
        }

        // Step 4: Given a string 't'
        String t = scanner.nextLine();
        // initialize it as 'Dog' or 'Bird'

        // Step 5: If 't' is 'Dog', create an instance of 'Dog' with 'name' as 'Rusty' and 'sound' as 'Bark'
        if (t.equals("Dog")) {
            Dog dog = new Dog("Rusty", "Bark");
            System.out.println("Name: " + dog.getName());
            System.out.println("Sound: " + dog.sound);
        }
        // Step 6: If 't' is 'Bird', create an instance of 'Bird' with 'name' as 'Tweety' and 'canFly' as true
        if (t.equals("Bird")) {
            Bird bird = new Bird("Tweety", true);
            System.out.println("Name: " + bird.getName());
            System.out.println("Can Fly: " + bird.canFly);
        }
        // Step 7: Print the instance variables
    }
}
```