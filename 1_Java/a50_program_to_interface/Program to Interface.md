GitHub Copilot: Programming to an interface means that you use the interface type as the declared type of your variables, return types of your methods, or parameters of your methods. Here are some examples:

1. **Declaring variables:**

```java
List<String> myList = new ArrayList<>();
```

In this example, `myList` is declared as a `List`, which is an interface, but it's initialized as an `ArrayList`, which is a concrete implementation of the `List` interface. This means you can easily change the implementation to a `LinkedList` or any other class that implements `List` without changing the rest of your code.

2. **Return types of methods:**

```java
public static List<String> getNames() {
    return new ArrayList<>();
}
```

In this example, the `getNames` method returns a `List`. This means that you can change the implementation of the list inside the method without affecting the code that calls this method.

3. **Parameters of methods:**

```java
public static void printList(List<String> list) {
    for (String s : list) {
        System.out.println(s);
    }
}
```

In this example, the `printList` method takes a `List` as a parameter. This means that you can pass any object that implements the `List` interface to this method.

In all these examples, you're programming to an interface (`List`), not a concrete implementation (`ArrayList`, `LinkedList`, etc.). This makes your code more flexible and easier to maintain.