//interface as variable
```java
Readable readable = new TextMessage("ope", "The text message is Readable!");
```

//interface as method parameter
```java
public class Printer {
    public void print(Readable readable) {
        System.out.println(readable.read());
    }
}
```
//One ReadingList can be added to another ReadingList because add(Readable readable) takes Readable as an method parameter, and ReadingList, like text Message, is also a Readable type object.
```java
public class ReadingList implements Readable {
    private ArrayList<Readable> readables;

    public void add(Readable readable) {
        this.readables.add(readable);
    }
}
ReadingList jonisList = new ReadingList();
ReadingList vernasList = new ReadingList();
vernasList.add(jonisList);
vernasList.read(); //reads both jonis and vernas list
```

//Interface as a return type of a method
```java
public class Factory {

    public Packable produceNew() {  //we can return any object that implements the Packable interface and it won't matter to the packer because it just takes Packable and add it into a box.
            return new Book("Kent Beck", "Test Driven Development", 0.7);
            return new CDDisk("Wigwam", "Nuclear Nightclub", 1975);
            return new ChocolateBar();
    }
}

public class Packer {
    private Factory factory;

    public Packer() {
        this.factory = new Factory();
    }

    public Box giveABoxOfThings() { //add Packable objects produced by factory into a box and return it
        Box box = new Box(100);
        Packable newThing = factory.produceNew();
        box.add(newThing);
        return box;
    }
}
```