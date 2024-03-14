# type == class
# object == instance

# object vs reference variables
Dog d = new Dog();

d is reference variable of type Dog.
new Dog() creates a new instance/object of Dog and assigns it to d.

# class/type = blueprint of house
# instance/object = built house

# primitive type != class
primitive types are NOT called classes.

# reference type != object
Dog d = new Dog();
left side reference.
right side object.
d is a reference variable of the reference type Dog.
new instantiates the class Dog and initialize it (initialize means assign values to the instance variables of the object) by calling its constructor

# initialization
primitive type: just assign value for first time.
object/instance: assigning value for the instance variables

# instantiation
primitive type: cannot be instantiated.
object/instance: use new to create new object/instance of the class












means create new object (instance of a class)
so cannot instatiate primitive type

you **define** (create) a class
you **instantiate** a class with the new keyword. creating a new instance (object) of the Car class
    Car myCar = new Car();

you **declare** an object
    Object object;
you **initialize** an object
```java
public class Car {
    private String color;

    public Car() {
        color = "Red"; // Initializing the color of the car
    }
}
```
for `int i = 0` you declare variable i of type int, and you initialize with initial value of 0;
there is no instantiation because int is a primitive type in Java, not an object.

# abstraction
abstraction: 萃取，提煉，摘要，提取
從這個角度，abstraction比較貼近期刊論文中常見的「摘要」這方面的意義。（期刊或論文中常會在開頭摘要出本文的要點，該節英文使用abstract一詞）所以我個人認為「摘錄」或「歸納」是更貼近中文為母語的人所認知的語義。我們並不會說：「我抽象化出車子有底盤、輪子、引擎、方向盤、煞車。」、而比較會說出類似「我歸納出車子有底盤、輪子、引擎、方向盤、煞車。」這樣的句子來。

# upcast
Upcasting is the process of referring to a subclass object with a reference variable of its superclass type.

# Instantiate
create new instance of a class
new Dog();

# Initialize
To initialize an object means to assign initial values to its fields or properties after it has been instantiated. Initialization can occur in various ways, such as through constructor methods, initialization blocks, or directly at the time of field declaration.

In Java, constructors play a significant role in the initialization process. When you instantiate an object, its constructor is called to initialize the object's fields with initial values or to perform any setup procedures required for the object's state.

For example:

```java
public class MyClass {
    private int value;

    public MyClass() {
        value = 10; // Initialization
    }
}
```
In this case, when a MyClass object is instantiated, its constructor initializes the value field to 10.

# argument vs parameters

Arguments: The things you specify between the parentheses when you’re invoking a method:
doStuff("a", 2);

Parameters: The things in the method’s signature that indicate what the method must receive when it’s invoked:
void doStuff(String s, int a) { }

