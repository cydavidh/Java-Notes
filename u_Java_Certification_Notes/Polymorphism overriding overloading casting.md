
============================================================================================

# compiler will only see reference type
```java
class Superclass {
    //nothing, no hello method.
}
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
# rules about exception when overriding
superclass method throw checked exception
subclass method (no throw at all / throw same / throw narrower exception)
<!-- e.g. superclass IOException <- subclass FileNotFoundException -->

==============================================================================
# exception when doing subtype polymorphism

superclass method has checked exception
```java
class Animal {
    void eat() throws Exception {
        // throw new Exception();
    }
}
```

subclass does not
```java
class Dog extends Animal {
    void eat() { 
        //no exception
    }
```

compile error, cuz compiler only see reference type
```java
Animal b = new Dog();
b.eat()
```

==============================================================================
# Exception and Overriding
unchecked dont worry. checked need to be caught/checked.

# unchecked exception
The overriding method CAN throw any unchecked (runtime) exception, regardless of whether the overridden method declares the exception. (More in Chapter 5.)

# checked exception
The overriding method must NOT throw checked exceptions that are new or broader than those declared by the overridden method. For example, a method that declares a FileNotFoundException cannot be overridden by a method that declares a SQLException, Exception, or any other nonruntime exception unless it’s a subclass of FileNotFoundException.

==============================================================================
#  Reference type determines which overloaded method is invoked

```java
//overloaded methods
doStuff(Animal a)
doStuff(Horse h)

Animal c = new Horse(); // Animal Reference type, Horse object/instance type
ua.doStuff(c); // will end up using doStuff(Animal a)
```

==============================================================================
# Summary
# overriden version - runtime - object type
# overloaded version - compile time - reference type

==============================================================================
# Casting
# downcast - explicit
```java
Animal a = new Dog();
Dog b = (Dog) a;
//this way wee can use method that only Dog has
b.playFetch();
```
# upcast - implicit but can also explicit 
```java
Dog d = new Dog();
Animal a = d; //implicit
Animal a = (Animal) d; //explicit
```

# will compile, but runtime error
```java
Animal animal = new Animal();
Dog d = (Dog) animal; //compiles but fails with
// java.lang.ClassCastException
```

# syntactically correct
```java
Animal a = new Dog();
((Dog) a).playFetch();
```

==============================================================================
# Covariant Return
# can change return type of overriding method if new type is subtype of superclass method return type

```java
class Alpha {
    Alpha doStuff() { return new Alpha() }
}
class Beta extends Alpha {
    Beta doStuff() { return new Beta() }
}
```

==============================================================================
# garbage collection test example
```java
class Beta { }
class Alpha {
    static Beta b1;
    Beta b2;
}

public class Tester {
    public static void main(String[] args) {
        Beta b1 = new Beta();   
        Beta b2 = new Beta();
        Alpha a1 = new Alpha(); 
        Alpha a2 = new Alpha();
        a1.b1 = b1; // static variable b1 of class Alpha is set to b1 Beta instance referred to by b1. `Alpha.b1 = Beta b1 = new Beta();`
        a1.b2 = b1; // instance variable of a1 Alpha instance is set to b1 Beta instance as well
        a2.b2 = b2; // instance variable of a2 Alpha instance is set to b2 Beta instance.
        a1 = null; // reference from a1 to the Alpha instance is removed. The Alpha instance still exists, and its b2 variable is still referencing the Beta instance, but this Alpha instance is now eligible for garbage collection since nothing reference to it.
        b1 = null; // refrence from b1 to the Beta instance is removed. But static variable b1 of class Alpha points to same Beta instance.
        b2 = null; // reference from b2 to the Beta instance is removed. But instance variable of a2 Alpha points to that Beta instance.
    }
}

```
in conclusion. only the Alpha instance that a1 references to is eligible for garbage collection at the end of the main method.

the a2 Alpha is never set to null so it points to its Alpha instance.
the b1 Alpha is pointed to by the static variable of Alpha class.
the b2 Alpha is pointed to by the instance variable of a2 Alpha instance, which is referenced by a2.

==============================================================================
# instanceof
```java
interface I { }
class A implements I{ }
class B extends A {
    public static void main(String[] args) {
        A temp = new B();
        sout(temp instanceof B); //true
        sout(temp instanceof Object); //true
        sout(temp instanceof I); //true

        B hello = new B();
        sout(hello instanceof I); //true because B extends A, and A implements I.
        // B is an instance of I because of inheritance.


        String a = null;
        sout(null instanceof String); //false

        int[] nums = new int[3];
        sout(nums instanceof Object); //true, arrays are objects/reference variables, even if it is array of primitive type
        // objects/reference variables always extends Object.
    }
}
```

cannot compare unrelated class
```java
class Dog {}
class Cat {
    public static void main(String[] args) {
        Dog d = new Dog();
        sout(d instanceof Cat); // compiler error.
    }
}
```