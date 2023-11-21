GitHub Copilot: In Java, the terms "implements" and "extends" are not the same thing. They are used in different contexts:

1. `implements`: This keyword is used when a class wants to use an interface. When a class implements an interface, it promises to provide implementations for all the methods declared in the interface. For example, `public class ArrayList<E> implements List<E>` means that the `ArrayList` class provides implementations for all the methods declared in the `List` interface.

2. `extends`: This keyword is used when a class wants to inherit from a superclass, or when an interface wants to inherit from another interface. The subclass inherits all the public and protected methods and fields of the superclass. For example, `public class CustomList<E> extends ArrayList<E>` means that `CustomList` inherits all the methods and fields of `ArrayList`.

So, when we say "`List` extends `Collection`", we mean that the `List` interface inherits from the `Collection` interface. When we say "`ArrayList` implements `List`", we mean that the `ArrayList` class provides implementations for all the methods declared in the `List` interface.

In your `Hand.java` file, you should replace `import java.util.Collection;` with `import java.util.List;` if you're using a `List` in your `Hand` class.