Certainly! Here are concise explanations of all five SOLID principles with updated examples, including the refined ISP example:

### 1. **Single Responsibility Principle (SRP)**
- **What it means**: A class should have one, and only one, reason to change, meaning it should only have one job.
- **Example**: A `Printer` class should only handle the printing process, not the responsibilities of document formatting or content management.

```java
public class Printer {
    public void printDocument(Document document) {
        System.out.println("Printing document");
    }
}
```

### 2. **Open/Closed Principle (OCP)**
- **What it means**: Software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification.
- **Example**: Using polymorphism to extend a class's behavior without modifying its existing code.

```java
public interface Shape {
    double area();
}

public class Circle implements Shape {
    private double radius;

    public Circle(double radius) {
        this.radius = radius;
    }

    public double area() {
        return Math.PI * radius * radius;
    }
}

public class Square implements Shape {
    private double side;

    public Square(double side) {
        this.side = side;
    }

    public double area() {
        return side * side;
    }
}
```

### 3. **Liskov Substitution Principle (LSP)**
- **What it means**: Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.
- **Example**: Subclasses should extend parent classes in a way that doesn't break functionality when used through a base class reference.

```java
public class Bird {
    public void fly() {
        System.out.println("Bird is flying");
    }
}

public class Duck extends Bird {
    @Override
    public void fly() {
        System.out.println("Duck is flying");
    }
}
```

### 4. **Interface Segregation Principle (ISP)**
- **What it means**: No client should be forced to depend on methods it does not use.
- **Example**: Creating specific interfaces for printer and scanner functionalities so that a printer client does not need to implement scanning methods.

```java
interface IPrinter {
    void print(Document d);
}

interface IScanner {
    void scan(Document d);
}

class SimplePrinter implements IPrinter {
    public void print(Document d) {
        System.out.println("Print document");
    }
}

class Photocopier implements IPrinter, IScanner {
    public void print(Document d) {
        System.out.println("Print document");
    }

    public void scan(Document d) {
        System.out.println("Scan document");
    }
}

class SimplePrinterClient {
    private IPrinter printer;

    public SimplePrinterClient(IPrinter printer) {
        this.printer = printer;
    }

    public void execute() {
        printer.print(new Document());
    }
}
```

### 5. **Dependency Inversion Principle (DIP)**
- **What it means**: High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details; details should depend on abstractions.
- **Example**: Using an interface to define storage mechanisms, allowing high-level modules to remain unaffected by changes in storage implementations.

```java
public interface Storage {
    void save(String data);
}

public class FileStorage implements Storage {
    public void save(String data) {
        System.out.println("Saving data to a file");
    }
}

public class DatabaseStorage implements Storage {
    public void save(String data) {
        System.out.println("Saving data to a database");
    }
}

public class DataManager {
    private Storage storage;

    public DataManager(Storage storage) {
        this.storage = storage;
    }

    public void saveData(String data) {
        storage.save(data);
    }
}
```

These examples succinctly capture the essence of the SOLID principles, demonstrating how they can be applied in Java to create a more maintainable, scalable, and robust software design.