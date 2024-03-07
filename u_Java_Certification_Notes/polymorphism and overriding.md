
============================================================================================

# compiler will only see reference type
```java
Superclass temp = new Subclass();
temp.hello() //will not compile because the type is Superclass. Superclass does not have that method.
```
This is because Java is a statically typed language, and the compiler needs to know that the methods being called on an object are valid based on the reference type.

# JVM will see instance type

```java
Superclass temp = new Subclass();
temp.instanceMethod() // if subclass overrides superclass instanceMethod(), then subclass version will be used.
```
Compiler still sees temp as Superclass reference, and checks if it has the instanceMethod() (which it does)

if instanceMethod() is overriden, then subclass version will be used.
This is because the JVM will use the actual type of the object (i.e., Subclass) to determine which version of the method to call.

subclass only can **override** instance methods. instance variables, static variables, static methods all cannot
suppose subclass has an instance method hello(). 

also the modifier of the overriding method must be less restrictive.


==============================================================================
# using the supertype version of the method
```java
class Animal {
    public void eat {
        sout("crunch");
    }
}
class Horse extends Animal {
    public void eat() {
        super.eat()
        sout("burp")
    }
}
```

```java
interface X {
    default void doStuff() {
        sout("X baby");
    }
}

interface Y extends X {
    @Override
    default void doStuff() {
        sout("Y money");
    }
}

class MyClass implements Y {
    void callSuperDoStuff() {
        X.super.doStuff(); //prints X baby
        Y.super.doStuff(); //prints Y money
        super.doStuff(); // prints Y money
    }
}
```


==============================================================================
# Exception with subtype polymorphism

```java
class Animal {
    void eat() throws Exception {
        // throw new Exception();
    }
}

class Dog extends Animal {
    void eat() { 
        //no exception
    }

    public static void main(String[] args) {
        Dog a = new Dog();
        a.eat() //no poblem, subclass version Dog no exception
        
        Animal b = new Dog();
        b.eat() // eventhough runtime the eat() method will be Dog version, compiler still see only reference type instead of instance type, so compiler error - unreported exception.
    }

}
```
If you use subtype polymorphism / polymorphic reference / supertype reference i.e. Animal b = new Dog();
If supertype method declare checked exception and subtype method does not
compiler still thinks you are calling a method that declares exception
since compiler only sees reference type eventhough run-time will use instance type.