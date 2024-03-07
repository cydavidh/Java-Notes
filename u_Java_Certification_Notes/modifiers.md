
```java
interface Bro {
    // public, static, final
    int fieldStaticFinal = 0;

    // abstract, public only
    int methodAbstractPublic();

    // public only
    default int methodDefault() { return 1; }

    // public only
    static int methodStatic() { return 2; }

    // java 9
    private int privateMethod() { return 3; }
    private static int privateStaticMethod() { return 4; }
}
```

```java
abstract class AbstractExample {
    // public, protected, private, package-private, final
    static int fieldStatic = 1;
    int fieldInstance = 2;

    // public, protected, package-private
    abstract void methodAbstract();
    
    // public, protected, private, package-private, static, final
    static void methodStatic() {;}
    void methodInstance() { }

    // Constructors - public, protected, private, package-private
    AbstractExample() { }
}

```
**remember, no semicolon ; after method body {} !!!**
```java
class Normal {
    // public, protected, private, package-private, final
    static int fieldStatic = 1;
    int fieldInstance = 2;
    
    // public, protected, private, package-private, static
    static void methodStatic() { }
    void methodInstance() { }

    // Constructors - public, protected, private, package-private
    Normal() { }



    // implement interface method, must be public, nothing else.
    public void method() { }

    // implement abstrct method, must be less restrictive than original
    // package private abstract method in superclass
    protected/public void method() { }
    // protected abstract method in superclass
    public void method() { }
}

```