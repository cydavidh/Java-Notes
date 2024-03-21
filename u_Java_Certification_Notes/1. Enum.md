```java
enum CoffeeSize { BIG, HUGE, GIANT }
```
```java
public class Coffee{
    CoffeeSize size;
}
```
```java
public class Cafe {
    public static void main(String[] args) {
        Coffee drink = new Coffee();
        drink.size = CoffeeSize.BIG;
    }
}
```
===================================================================================================
```java
enum CoffeeSize {
    BIG(8), HUGE(10), GIANT(16);

    private int ounces;

    CoffeeSize(int ounces) {
        this.ounces = ounces;
    }

    public int getOunces() {
        return this.ounces;
    }
}
```

```java
class Coffee {
    CoffeeSize size;

    public static void main(String[] args) {
        Coffee  drink1 = new Coffee();
        drink1.size = CoffeeSize.BIG;
        sout(drink1.size.getOunces()); // prints 8
    }
}
```

Every enum has a static method, values(), that returns an array of the enum’s values in the order they’re declared.
```java
class Main {
    public static void main(String[] args) {
        CoffeeSize[] sizes = CoffeeSize.values();
        for (CoffeeSize cs : CoffeeSize.values()) {
            System.out.println(cs + " " + cs.getOunces());
            /*prints:
             *BIG 8
             *HUGE 10
             *OVERWHELMING 16
             */
        }
    }
}
```
========================================================================================================
You want enums to have two methods—one for ounces and one for lid code (a String). Now imagine that most coffee sizes use the same lid code, “B”, but the OVERWHELMING size uses type “A”.
 ```java
 enum CoffeeSize {
    BIG(8),
    HUGE(10),
    OVERWHELMING(16) { // start a code block that defines the "body" for this constant
        public String getLidCode() { // override the method defined in CoffeeSize
            return "A";
        }
    }; // the semicolon is REQUIRED when more code follows

    CoffeeSize(int ounces) {
        this.ounces = ounces;
    }

    private int ounces;

    public int getOunces() {
        return ounces;
    }

    public String getLidCode() { // this method is overridden by the OVERWHELMING constant
        return "B";
    } // the default value we want to return for CoffeeSize constants
}
 ```