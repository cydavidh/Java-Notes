```java
abstract class AbstractObject {
   public abstract void method(); //abstract methods do not specify a body.
}

class ImplementingObject extends AbstractObject {
  public void method() {
    // doSomething();
  }
}
```