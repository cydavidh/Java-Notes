```java
public class Pipe<T> {
    private LinkedList<T> list;

    public Pipe() {
        list = new LinkedList<>();
    }

    public void putIntoPipe(T value) {
        list.add(value);
    }
}
```
```java
public class Hideout<T> {
    private T object;

    public Hideout() {
        this.object = new T(); //not gonna work
    }

    public void putIntoHideout(T toHide) {
        this.object = toHide; //necessary
    }

    public T takeFromHideout() {
        T temp = this.object;
        this.object = null;
        return temp;
    }

    public boolean isInHideout() {
        return this.object != null;
    }
}
```

At compile time, compiler converts your code to `bytecode`, which will be executed by JVM at runtime.

At compile time, `type erasure` happens.

`Type erasure` is replacing `T` with its upper bound, or `Object` if none is declared.

However, this doesn't mean that `T` becomes an instance of `Object`. It means that any instance of `T` is treated as an instance of `Object`. 

This is why you can't use `new T()` in generic code. The compiler doesn't know the actual class to instantiate because `T` could be any type that extends `Object`.

So, in your `Hideout` class, you can't do `this.object = new T();` in the constructor. The specific type of `T` is only known at compile time, not at runtime. Therefore, the Java compiler doesn't have the information it needs to create a new instance of `T` with `new T()`.

```java
Pipe<String> pipe = new Pipe<>(); 
putIntoPipe(123);
```
The compiler uses String as expected type for T when checking for type errors.































cydavidh: how is it that we can initialize this linked list in the parameterless contructor of Pipe class but we can't for the object in the Hideout class?
```
public class Pipe<T> {
    private LinkedList<T> list;

    public Pipe() {
        list = new LinkedList<>();
    }

    public void putIntoPipe(T value) {
        list.add(value);
    }
}
```
```
public class Hideout<T> {
    private T object;

    public Hideout() {}

    public void putIntoHideout(T toHide) {
        this.object = toHide;
    }

    public T takeFromHideout() {
        T temp = this.object;
        this.object = null;
        return temp;
    }

    public boolean isInHideout() {
        return this.object != null;
    }
}
```

GitHub Copilot: The difference between the `Pipe` and `Hideout` classes lies in the types of their fields and the nature of the objects they are dealing with.

In the `Pipe` class, the field `list` is of type `LinkedList<T>`. `LinkedList` is a class, and you can create a new instance of it using the `new` keyword, which is what happens in the `Pipe` constructor with `list = new LinkedList<>();`.

On the other hand, in the `Hideout` class, the field `object` is of a generic type `T`. This `T` can be any type -- a class type, an interface type, an array type, a primitive type, or even another type variable. When `T` is a class type, you can't instantiate it directly in the `Hideout` constructor because at runtime, the Java compiler erases all type parameters and replaces each with its first bound, which is `Object` if no explicit bounds are declared. This is known as type erasure. 

Therefore, you can't do something like `object = new T();` in the `Hideout` constructor because the compiler doesn't know the actual class of `T`. Instead, you have to rely on the `putIntoHideout(T toHide)` method to get an instance of `T` and assign it to the `object` field.

cydavidh: if we can't do `new T()`, how is it that we can do `new LinkedList<>()`?

GitHub Copilot: The difference lies in what `T` and `LinkedList<>` represent.

`T` is a type parameter. It's a placeholder for any type, and it doesn't represent a specific class. When you write `new T()`, the Java compiler doesn't know what type to instantiate, because `T` could be any type. This is why `new T()` is not allowed in Java.

On the other hand, `LinkedList<>` is a specific class. When you write `new LinkedList<>()`, the Java compiler knows that it needs to create a new instance of the `LinkedList` class. The `<>` (diamond) operator tells the compiler to infer the type arguments. If you're adding this `LinkedList` to a field or variable that has a specific generic type, like `LinkedList<T>`, the compiler can infer that the type argument is `T`.

So, `new LinkedList<>()` is allowed because `LinkedList<>` is a specific class, while `new T()` is not allowed because `T` is a type parameter and doesn't represent a specific class.

cydavidh: but when we use the constructor of the Pipe class we haven't given the type yet, how is the compiler supposed to infer the type before initializing the lists?

GitHub Copilot: When you create an instance of the `Pipe` class, you specify the type at that point. For example, if you create a `Pipe` of `String`, you would do:

```java
Pipe<String> pipe = new Pipe<>();
```

Here, `String` is the type argument that replaces `T` in the `Pipe` class. So, the `LinkedList<T>` in the `Pipe` class becomes `LinkedList<String>`.

When you call the constructor with `new Pipe<>()`, the compiler infers the type from the left-hand side of the assignment. This is known as "type inference". The `<>` (diamond) operator tells the compiler to infer the type arguments. 

So, even though the `Pipe` constructor doesn't explicitly specify the type of `T`, the compiler can infer it from the context in which the constructor is called. This inferred type is then used to initialize the `LinkedList<T>`.

cydavidh: ```    public Hideout() {
        this.object = new T();
    }```

GitHub Copilot: The code you've posted attempts to create a new instance of a generic type `T` with `new T()`. However, in Java, you cannot directly instantiate a generic type like this.

The reason for this is due to type erasure -- the Java compiler erases all type parameters and replaces each with its first bound, which is `Object` if no explicit bounds are declared. This means that at runtime, the JVM doesn't know what `T` is.

Instead of trying to instantiate `T` in the constructor, you should assign a value to `object` using a method, like you've done with `putIntoHideout(T toHide)`.

Here's how you can do it:

```java
public class Hideout<T> {
    private T object;

    public Hideout() {}

    public void putIntoHideout(T toHide) {
        this.object = toHide;
    }

    // other methods...
}
```

In this code, `putIntoHideout(T toHide)` assigns a value to `object`. You can call this method with an instance of `T` to put it into the hideout.

cydavidh: but can't the compiler infer the type when we use the constructor?
```Hideout<String> asdf = new Hideout<>();```

GitHub Copilot: Yes, the compiler can infer the type when you use the constructor, as in your example:

```java
Hideout<String> asdf = new Hideout<>();
```

Here, `String` is the type argument that replaces `T` in the `Hideout` class. So, the `T` in the `Hideout` class becomes `String`.

However, even though the compiler can infer the type `T` to be `String`, you still cannot create a new instance of `T` directly in the constructor of `Hideout` class with `new T()`. This is because at runtime, due to type erasure, the JVM doesn't know what `T` is.

Instead, you should assign a value to `object` using a method, like you've done with `putIntoHideout(T toHide)`. This method takes an argument of type `T`, so you can pass in a `String` when you call it:

```java
asdf.putIntoHideout("hello");
```

In this code, `"hello"` is a `String` that gets passed to `putIntoHideout(T toHide)`, and it gets assigned to `object`.

cydavidh: "The code you've posted attempts to create a new instance of a generic type T with new T(). However, in Java, you cannot directly instantiate a generic type like this.

The reason for this is due to type erasure -- the Java compiler erases all type parameters and replaces each with its first bound, which is Object if no explicit bounds are declared. This means that at runtime, the JVM doesn't know what T is."

can you explain more? I don't understand?

GitHub Copilot: Sure, I'll try to explain it in more detail.

In Java, generics are a compile-time concept. This means that when you write code using generics, the Java compiler uses them to enforce strict type checking at compile-time and to support generic programming (writing code that can be reused for different types).

However, once your code is compiled, these generic types are removed. This process is known as type erasure. The Java compiler replaces all generic types with their bounds or with `Object` if the type parameters are unbounded. The bytecode does not contain any information about the generic types. This is why you can't use `new T()` to create a new instance of a generic type -- because at runtime, the JVM doesn't know what `T` is.

For example, if you have a generic class `Box<T>`, the Java compiler replaces `T` with `Object` in the bytecode. So, at runtime, all `Box` objects are just `Box` objects that can hold an `Object`.

This is a fundamental aspect of how generics work in Java. It allows you to write code that is type-safe at compile-time, but it also means that you can't use generics in certain ways at runtime, such as creating instances of a generic type with `new T()`.

cydavidh: "Sure, I'll try to explain it in more detail.

In Java, generics are a compile-time concept. This means that when you write code using generics, the Java compiler uses them to enforce strict type checking at compile-time and to support generic programming (writing code that can be reused for different types).

However, once your code is compiled, these generic types are removed. This process is known as type erasure. The Java compiler replaces all generic types with their bounds or with Object if the type parameters are unbounded. The bytecode does not contain any information about the generic types. This is why you can't use new T() to create a new instance of a generic type -- because at runtime, the JVM doesn't know what T is.

For example, if you have a generic class Box<T>, the Java compiler replaces T with Object in the bytecode. So, at runtime, all Box objects are just Box objects that can hold an Object.

This is a fundamental aspect of how generics work in Java. It allows you to write code that is type-safe at compile-time, but it also means that you can't use generics in certain ways at runtime, such as creating instances of a generic type with new T()."


what's bytecode

GitHub Copilot: Bytecode in Java is the intermediate representation of your source code that the Java compiler produces after you compile your program. It's a low-level code that is designed to be easily executed by the Java Virtual Machine (JVM).

When you write a Java program and then compile it using the Java compiler, the compiler takes your high-level Java code and translates it into bytecode, which is stored in .class files. This bytecode is not human-readable, but it's closer to machine code than the original Java source code.

The JVM reads and executes bytecode instructions one by one. Because bytecode is designed to be platform-independent, you can run it on any device that has a JVM, regardless of the underlying hardware and operating system. This is what makes Java "write once, run anywhere".

So, in the context of our discussion about generics, when the Java compiler compiles your code, it replaces all generic types with their bounds or with `Object` in the bytecode. This is why you can't use `new T()` to create a new instance of a generic type at runtime -- because the JVM, which executes the bytecode, doesn't know what `T` is.

cydavidh: so during compile-time, type erasure happens. But because new T() isn't a type, so type erasure doesn't apply to T(). And that's why JVM doesn't know what it is?

GitHub Copilot: Not quite. Type erasure does apply to `T`, but it's not about `T` not being a type. `T` is a type parameter, which means it stands in for any type. When you write `new T()`, the Java compiler doesn't know what type to instantiate, because `T` could be any type.

During type erasure, the Java compiler replaces `T` with its bound or `Object` if no bounds are declared. So, at runtime, the JVM sees `T` as `Object`, and `new Object()` doesn't make sense if `T` is supposed to be a specific type like `String`, `Integer`, etc.

That's why you can't use `new T()`. The JVM, which executes the bytecode, doesn't know what `T` is at runtime due to type erasure. It only knows that `T` is an `Object`, but `Object` is not a concrete class that can be instantiated with `new`. 

This is a limitation of how generics are implemented in Java. They provide type safety at compile time, but they have limitations at runtime due to type erasure.

cydavidh: what is bound?

GitHub Copilot: In the context of Java generics, a bound is a restriction on what types can be used as the actual type parameter. 

When declaring a generic type parameter, you can specify an upper bound to restrict the types that can be used. This is done using the `extends` keyword. For example, in the following code, `T` is a type parameter that is bounded by the `Number` class:

```java
public class Box<T extends Number> {
    // ...
}
```

In this case, `T` can be any type that is a `Number` or a subclass of `Number`. This includes classes like `Integer`, `Double`, `Float`, etc. You couldn't use a type like `String` for `T` because `String` is not a subclass of `Number`.

If no explicit bound is given, the type parameter is implicitly bounded by `Object`, meaning it can be any type. This is why, during type erasure, unbounded type parameters are replaced with `Object`.

cydavidh: so type erasure isn't replacing the generics with the actual type like String?

GitHub Copilot: Correct, type erasure does not replace the generic type parameter `T` with the actual type like `String` at runtime. Instead, it replaces `T` with its upper bound, or `Object` if no explicit upper bound is declared.

This is because generics in Java are a compile-time concept designed to provide stronger type checks. The Java compiler uses the actual type (like `String`) to enforce these type checks at compile time, but it doesn't embed this information into the compiled bytecode for use at runtime.

So, when you see `T` in your code, the Java compiler sees it as `Object` after type erasure during the compilation process. This is why you can't do `new T()` in your code -- because at runtime, the JVM doesn't know what `T` is, it only knows that `T` is an `Object`.