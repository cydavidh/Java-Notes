legal identifier for names of variable, method, classes, interfaces, labels, and more.

1. start with abc, _, or $
2. continue with abc, _, &, or 123.
3. no keywords
4. unlimited length.

legal example:
int _a;
int $c;
int ______2_w;
int _$;
int this_is_identifier

illegal example
int :b;
int -d;
int e#;
int .f;
int 7g;


===================================================================================================================

arrows -> in the UML diagram means that the lower -> (knows about the) higher class.
lower imports ->  higher 
lower extends -> higher
===================================================================================================================

public static void main(String[] args)
public static void main(String args[])
public static void main(String... args)
===================================================================================================================
# declare array
int[] key
int []key
int key [];
int key[];
int[][] key;
int []key[]; // int[][] key
int[] key [][]; // int[][][] key
===================================================================================================================
public class SandBox {
    public static void main(String[] args) {
        System.out.println(args[0] + args[1])
    }
}

javac Sandbox.java 
//compiles source code to bytecode, producing Sandbox.class that can be run on JVM

java Sandbox x 1
//runs the Java program contained in the Sandbox class.

output:
x1


java -cp ".;C:\temp\someOtherLocation;c:\temp\myJar.jar" myPackage.MyClass
. means current directory.
the other two location are the files you want to import from other places.
===================================================================================================================

string = "asdf
asdf"
doesn't compile.
===================================================================================================================
# import statement 
import certification.*;
class AnnualExam {
ExamQuestion eq;
MultipleChoice mc;
}

Imports all classes and interfaces from certification


wildcard* won't import the whole package tree. only at that level.


import static certification.ExamQuestion.marks; //imports a field: 'static public int mark' of the ExamQuestion class
import static certification.ExamQuestion.*;
class AnnualExam {
    AnnualExam() {
    marks = 20;
    print();
    }
}
===================================================================================================================
# access modifiers: package-private, public, private, protected

**default** (package-private) (package access)
members with package access are only accessible to classes and interfaces defined in the same package.

Default access can be compared to package-private (accessible
only within a package), and protected access can be compared to package-
private + kids (“kids” refer to derived classes). Kids can access protected
methods only by inheritance and not by reference (accessing members by
using the dot operator on an object).

**protected**
members of a class defined using the protected access modifier are accessible to
■ Classes and interfaces defined in the same package
■ All derived classes, even if they’re defined in separate packages

A subclass in a different package can access a protected member only through inheritance. That is, it can access the protected member directly on its own instances or instances of its subclasses, but not on an arbitrary instance of the superclass.
// In file A.java
package package1;
public class A {
    protected int x = 10;
}

// In file B.java
package package2;
import package1.A;
public class B extends A {
    void method(B b, A a) {
        b.x = 20; // OK, 'b' is of type B, which is a subclass of A
        a.x = 20; // Compile error, 'a' is of type A, not a subclass
    }
}

===================================================================================================================
# non-access modifiers: final modifier
class Person {
final StringBuilder name = new StringBuilder("Sh");
Person() {
name.append("reya"); //Can call methods on a final variable that change its state
name = new StringBuilder(); // Won’t compile. You can’t reassign another object to a final variable.
}
}

In other words, a final reference still allows you to modify the state of the object it refers to, but you can’t modify the reference variable to make it refer to a different object. 

**Burn this in: there are no final objects, only final references.**

public Record getRecord(int fileNumber, final int recNumber) {}
public Record getRecord(int fileNumber, final String recNumber) {}
public Record getRecord(int fileNumber, final ArrayList<String> recNumber) {}

1. **`public Record getRecord(int fileNumber, final int recNumber) {}`**
   - This method takes an `int` as the `recNumber` parameter. Being a primitive type, `recNumber` is passed by value, meaning the method receives a copy of the argument. The `final` keyword ensures that the `recNumber` parameter cannot be reassigned within the method body, but this is less impactful here since `int` is a primitive type and modifying it directly is not possible anyway; you can only use its value.

2. **`public Record getRecord(int fileNumber, final String recNumber) {}`**
   - In this version, `recNumber` is a `String`. `String` objects in Java are immutable, so even though you can't reassign `recNumber` to a different `String` (because of the `final` modifier), you wouldn't be able to modify its state regardless. The immutability of `String` means any operation that seems to alter it (e.g., concatenation) actually results in a new `String` object.

3. **`public Record getRecord(int fileNumber, final ArrayList<String> recNumber) {}`**
   - This method accepts an `ArrayList<String>` as `recNumber`. The `final` keyword prevents reassignment of `recNumber` to a different `ArrayList` object, but you can modify the list's contents (add, remove, update elements). This is significant because it means the state of the object passed as `recNumber` can be altered within the method, potentially affecting other parts of your program that use the same list.

===================================================================================================================
# interface variables
interface variables are constant
public final and static

interface Foo {
    int topG = 0;
    void go();
}

class Zap implements Foo {
    public void go() {
        topG = 30; //won't compile
    }
}
============================================================================================
# interface static methods
interface static methods.

interface Foo {
    static int m1() {
        return 0;
    }
}

