https://stackoverflow.com/questions/1913098/what-is-the-difference-between-an-interface-and-abstract-class


# Interfaces

An interface is a contract: The person writing the interface says, "hey, I accept things looking that way", and the person using the interface says "OK, the class I write looks that way".

An interface is an empty shell. There are only the signatures of the methods, which implies that the methods do not have a body. The interface can't do anything. It's just a pattern.

For example (pseudo code):

```java
// I say all motor vehicles should look like this:
interface MotorVehicle
{
    void run();

    int getFuel();
}

// My team mate complies and writes vehicle looking that way
class Car implements MotorVehicle
{

    int fuel;

    void run()
    {
        print("Wrroooooooom");
    }


    int getFuel()
    {
        return this.fuel;
    }
}
```
Implementing an interface consumes very little CPU, because it's not a class, just a bunch of names, and therefore there isn't any expensive look-up to do. It's great when it matters, such as in embedded devices.


# Abstract classes

Abstract classes, unlike interfaces, are classes. They are more expensive to use, because there is a look-up to do when you inherit from them.

Abstract classes look a lot like interfaces, but they have something more: You can define a behavior for them. It's more about a person saying, "these classes should look like that, and they have that in common, so fill in the blanks!".

For example:
```java
// I say all motor vehicles should look like this:
abstract class MotorVehicle
{

    int fuel;

    // They ALL have fuel, so lets implement this for everybody.
    int getFuel()
    {
         return this.fuel;
    }

    // That can be very different, force them to provide their
    // own implementation.
    abstract void run();
}

// My teammate complies and writes vehicle looking that way
class Car extends MotorVehicle
{
    void run()
    {
        print("Wrroooooooom");
    }
}
```

# Implementation
While abstract classes and interfaces are supposed to be different concepts, the implementations make that statement sometimes untrue. Sometimes, they are not even what you think they are.

In Java, this rule is strongly enforced, while in PHP, interfaces are abstract classes with no method declared.

In Python, abstract classes are more a programming trick you can get from the ABC module and is actually using metaclasses, and therefore classes. And interfaces are more related to duck typing in this language and it's a mix between conventions and special methods that call descriptors (the __method__ methods).

As usual with programming, there is theory, practice, and practice in another language :-)