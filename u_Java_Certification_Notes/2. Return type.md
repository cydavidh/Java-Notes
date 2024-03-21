==============================================================================
# return type
1. With object reference return type, can return null
2. With primitive return type, can return anything that can be implicitly converted.
```java
public int foo() {
    char c = "c";
    return c; // char can be converted to int
}
```
3. With primitive return type, can cast to return type
```java
public int foo() {
    float f = 32.5f
    return (int) f
}
```
4. With void return type, DON'T return
```java
public void foo() {
    return "hello"; // Illegal
}
```
5. With Object referecne return type, can return anything that can be implicitly converted.
int[] IS-A Object
Horse IS-A Animal
Gum IS-A Chewable
```java
public Object getObject() {
    int[] nums = {1,2,3};
    return nums;
}

public Animal getAnimal() {
    return new Horse();
}

public interface Chewable {}
public class Gum implements Chewable {}

publci class Hello {
    public Chewable getChewable() {
        return new Gum(); //return class that implements interface.
    }
}
```