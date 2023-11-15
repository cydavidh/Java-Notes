```java
public abstract class GraphicObject {
  private String name; // declare fields

  public GraphicObject(String name) { // declare nonabstract methods
    this.name = name;
  }

  abstract void draw(); //abstract methods do not specify a body.
}

class ImplementingObject extends GraphicObject {
  public ImplementingObject(String name) {
    super(name);
  }

  public void draw() {
    // doSomething();
    System.out.println("hi");
  }
}
```


