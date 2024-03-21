
# how inheritance works, inherit basics.

```java
class SuperClass {
    static int i; //automatically initialized to 0
    int j;

    static int superclassStaticMethod() { return 0; }

    int superclassInstanceMethod() { return 0; }
}

interface Interface {
    int k = 0; //must initialize constant, public final static constant

    default int interfaceDefaultMethod() { return 0;} //public

    static int interfaceStaticMethod() { return 0; } //public

    int interfaceInstanceMethod(); //abstract
}

public class Subclass extends SuperClass or implements Interface{
    @Override
    public int superclassInstanceMethod() { return 123; }

    @Override //implement interface method, same notation
    public int interfaceInstanceMethod() { return 0; } // implementing method must be public

    public static void main(String[] args) {
        ===============================================================================================
        Subclass temp = new Subclass();
        //static variable
        i // same for interface, you can access the field without the Superclass/Interface name.
        Superclass.i
        Subclass.i
        temp.i
        //you can change it directly without assignment
        i+=1
        //and i will now be 1 until the end of program
        //forever in another way essentially

        //instance variable
        temp.j

        //static method
        method1()
        SuperClass.method1()
        Subclass.method1()
        temp.method1()

        //instance method
        temp.superclassInstanceMethod()
        =============================================================================================
        Interface temp2 = new Subclass();

    }
}
```
=================================================================