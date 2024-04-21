The Java code you've provided is as follows:

```java
class Mammal {
    String name = "furry ";
    String makeNoise() { return "generic noise"; }
}

class Zebra extends Mammal {
    String name = "stripes ";
    String makeNoise() { return "bray"; }
}

public class ZooKeeper {
    public static void main(String[] args) { new ZooKeeper().go(); }
    void go() {
        Mammal m = new Zebra();
        System.out.println(m.name + m.makeNoise());
    }
}
```

In this code, when `System.out.println(m.name + m.makeNoise());` is called, `m.name` refers to the `name` property of the `Mammal` class, not the `name` property of the `Zebra` class. This is because fields in Java are not polymorphic, so they do not override one another like methods do. Since the type of the reference `m` is `Mammal`, the `name` field of `Mammal` is used.

However, the `makeNoise()` method is called on the `m` object, which is an instance of `Zebra`. Because methods are polymorphic in Java, the `makeNoise()` method of the `Zebra` class is invoked. This is because at runtime, Java uses the actual object's method, not the reference type's method. This runtime behavior is known as dynamic method dispatch or method overriding, which is a key aspect of polymorphism in object-oriented programming.

So, the output of the `System.out.println(m.name + m.makeNoise());` statement will be:
```
furry bray
```

It uses `Mammal`'s `name` field and `Zebra`'s `makeNoise()` method.