# Enum

```java
public enum Suit {
    DIAMOND, SPADE, CLUB, HEART
}

Suit suit = Suit.DIAMOND;
```
# Enum constants, are they public?

Yes, the enum constants DIAMOND, SPADE, CLUB, and HEART are implicitly *public*, *static*, and *final*. This means:
*public* - they can be accessed anywhere, 
*static* - they belong to the Suit enum itself (rather than an instance of the enum), 
*final* - their values cannot be changed once they are created.

# Example of an enum in Java that contains instance variables:

```java
public enum Animal {
    DOG("Dog", "Bark"),
    CAT("Cat", "Meow"),
    COW("Cow", "Moo");

    private String name;
    private String sound;

    
    private Animal(String name, String sound) {
        this.name = name;
        this.sound = sound;
    }

    public String getName() {
        return name;
    }

    public String getSound() {
        return sound;
    }
}
```

In this example, each constant in the `Animal` enum has a `name` and a `sound` field, which are instance variables. The fields are initialized using a constructor, and there are getter methods `getName()` and `getSound()` to retrieve the name and sound of the animal.

You can use this enum in your code like this:

```java
public class Main {
    public static void main(String[] args) {
        Animal animal = Animal.DOG;
        System.out.println("Animal name: " + animal.getName());
        System.out.println("Animal sound: " + animal.getSound());
    }
}
```

When you run this code, it will print:

```
Animal name: Dog
Animal sound: Bark
```


# Animal.DOG as parameter for Animal animal: usage

```java
public class Cage() {
    private String name;
    private Animal animal;

    public Cage(String name, Animal animal) {
        this.name = name;
        this.animal = animal;
    }

    public Animal getAnimal() {
        return this.animal;
    }
}

public class Main {
    public static void main(String[] args) {
        Cage cage1 = new Cage("Cage1", Animal.DOG)
        System.out.println("Cage 1: " + cage1.getAnimal().name()); // Cage 1: DOG
        //built-in method .name() 
    }
}
```

# built-in toString methods
# call name with .name()

