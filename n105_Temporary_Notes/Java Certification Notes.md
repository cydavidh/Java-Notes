arrows -> in the UML diagram means that the lower -> (knows about the) higher class.
lower imports ->  higher 
lower extends -> higher

public static void main(String[] args)
public static void main(String args[])
public static void main(String... args)

java -cp ".;C:\temp\someOtherLocation;c:\temp\myJar.jar" myPackage.MyClass
. means current directory.
the other two location are the files you want to import from other places.

string = "asdf
asdf"
doesn't compile.

import certification.*;
class AnnualExam {
ExamQuestion eq;
MultipleChoice mc;
}

Imports all classes and
interfaces from certification


wildcard* won't import the whole package tree. only at that level.


import static certification.ExamQuestion.marks; //imports a field: 'static public int mark' of the ExamQuestion class
import static certification.ExamQuestion.*;
class AnnualExam {
AnnualExam() {
marks = 20;
print();
}
}

protected
members of a class defined using the protected access modifier are accessible to
■
Classes and interfaces defined in the same package
■
All derived classes, even if they’re defined in separate packages

default (package-private) (package access)
members with package access are only accessible to classes and interfaces defined in the same package.

Default access can be compared to package-private (accessible
only within a package), and protected access can be compared to package-
private + kids (“kids” refer to derived classes). Kids can access protected
methods only by inheritance and not by reference (accessing members by
using the dot operator on an object).


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


class Person {
final StringBuilder name = new StringBuilder("Sh");
Person() {
name.append("reya"); //Can call methods on a final variable that change its state
name = new StringBuilder(); // Won’t compile. You can’t reassign zanother object to a final variable.
}
}