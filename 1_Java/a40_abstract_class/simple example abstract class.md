```java
public abstract class Animal {
  private String name; // declare fields

  public Animal(String name) { // declare nonabstract methods
    this.name = name;
  }

  abstract void makeSound(); //abstract methods do not specify a body.
}

class Cat extends Animal {
  public Cat(String name) {
    super(name);
  }

  public void makeSound() {
    // doSomething();
    System.out.println("Meow");
  }
}
```