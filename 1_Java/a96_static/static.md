a static method can access only static fields and cannot access non-static fields;

a static method can invoke another static method, but it cannot invoke an instance method;

a static method cannot refer to this keyword because there is no instance in the static context.

Instance methods, however, can access static fields and methods.

```java

public class SomeClass {
    static String staticString;
    String instanceString;
    
    public SomeClass() {
        invokeAnInstanceMethod(); // this is possible here
        invokeAStaticMethod();    // this is possible here too
        sout(staticString);
        sout(this.instanceString);
    }
    
    public static void invokeAStaticMethod() { 
        // it's impossible to invoke invokeAnInstanceMethod() here
        sout(staticString);
    }
    
    public void invokeAnInstanceMethod() { 
        invokeAStaticMethod();  // this is possible
        sout(staticString);
        sout(this.instanceString);
    }
}
```