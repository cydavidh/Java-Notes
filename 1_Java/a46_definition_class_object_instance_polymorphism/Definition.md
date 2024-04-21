# Definitions
Object = Instance 
Type = Class (int, String), Interface (Runnable, Comparable, Serializable), enum

# Object hello = new String("asdf")
you are declaring a variable named hello of type Object and initializing it with a new instance of the String class.

The String instance is created with the value "asdf". Because String is a subclass of Object in Java, you can assign an instance of String to a variable of type Object. This is an example of polymorphism, a fundamental concept in object-oriented programming.

# Upcasting = Subtype Polymorphism
Upcasting is an example of implicit or widening reference conversion, which is a form of polymorphism known as subtyping polymorphism or inclusion polymorphism.

Subtyping polymorphism allows a subclass to be treated as an instance of its superclass. In the case of upcasting, we are treating an instance of a subclass as an instance of its superclass. This is possible because the subclass inherits all the properties and behaviors of its superclass, and can therefore be used in any context where the superclass is expected.

Upcasting is a common technique in Java and other object-oriented programming languages, and is often used to create more flexible and reusable code. By upcasting objects to their superclass types, we can write code that works with a wide range of objects, without having to know the specific subclass of each object.

# Class and Object
In object-oriented programming, a class is a blueprint or template for creating objects, while an object is an instance of a class.

A class defines the properties and behaviors of objects, while an object is a specific instance of a class that has its own state and behavior.

In simpler terms, a class is like a blueprint or a set of instructions for creating objects, while an object is an actual instance of that class with its own unique characteristics.

In Java, an array is not a class, but it is an object. An array is a container object that holds a fixed number of values of a single data type. However, arrays are implemented as classes in Java, and they inherit from the Object class.

# Arrays class and arrays data type
You are correct that there is a class called Arrays in Java. The Arrays class is a utility class that provides various methods for working with arrays, such as sorting, searching, and filling arrays.

However, when we talk about arrays in Java, we are usually referring to the array data type, which is not a class. An array is a container object that holds a fixed number of values of a single data type.

In Java, arrays are implemented as objects, but they are not instances of a class. Instead, arrays are a special type of object that is created using a special syntax. For example, we can create an array of integers using the following syntax:

int[] numbers = new int[5];


In this example, we are creating an array of integers with a length of 5. The int[] syntax indicates that we are creating an array of integers, and the new int[5] syntax creates a new array object with a length of 5.

So, while the Arrays class provides methods for working with arrays, the array data type itself is not a class.