```java
class BrokenInvariants {
    public static void main(String[] args) {
        Cat casper = new Cat("Casper", -1);
    }
}

class Cat {
    String name;
    int age;
    public Cat(String name, int age) {
        assert (age >= 0) : "Invalid age";
        this.name = name;
        this.age = age;
    }
}

```

add -ea flag