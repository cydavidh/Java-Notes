package n24_objects_is_a_reference_variable.n11_objects_and_references;

//Assigning a reference type variable copies the reference
```java
Person joan=new Person("Joan Ball");
System.out.println(joan);

Person ball=joan;
```

// Object as a method parameter
```java
public class AmusementParkRide {
    private String name;
    private int lowestHeight;

    public AmusementParkRide(String name, int lowestHeight) {
        this.name = name;
        this.lowestHeight = lowestHeight;
    }

    public boolean allowedToRide(Person person) {
        if (person.getHeight() < this.lowestHeight) {
            return false;
        }

        return true;
    }
}
```

// Object as object variable (instance variable)
```java
public class Person {
    private String name;
    private SimpleDate birthday;

    public Person(String name, SimpleDate date) {
        this.name = name;
        this.birthday = date;
    }
}
```

// Object of same type as method parameter
```java
public class SimpleDate {
    private int day;
    private int month;
    private int year;

    public SimpleDate(int day, int month, int year) {
        // ...
    }

    public boolean before(SimpleDate compared) {
        // first compare years
        if (this.year < compared.year) {
            return true;
        }

        if (this.year > compared.year) {
            return false;
        }

        // years are same, compare months
        if (this.month < compared.month) {
            return true;
        }

        if (this.month > compared.month) {
            return false;
        }

        // years and months are same, compare days
        if (this.day < compared.day) {
            return true;
        }

        return false;
    }
}

public class Person {
    // ...

    public boolean olderThan(Person compared) {
        if (this.birthday.before(compared.getBirthday())) {
            return true;
        }

        return false;
    }}

    // Comparing the equality of objects (equals)
    SimpleDate first = new SimpleDate(1, 1, 2000);
    SimpleDate second = new SimpleDate(1, 1, 2000);
    first.equals(second) // false, from the point of view of the default equals method.
    // so we need to implement our own equals method

    public class SimpleDate {
        // ...
        public boolean equals(Object compared) {
            // if the variables are located in the same position, they are equal
            if (this == compared) {
                return true;
            }

            // if the type of the compared object is not SimpleDate, the objects are not
            // equal
            if (!(compared instanceof SimpleDate)) {
                return false;
            }

            // convert the Object type compared object
            // into a SimpleDate type object called comparedSimpleDate
            SimpleDate comparedSimpleDate = (SimpleDate) compared;

            // if the values of the object variables are the same, the objects are equal
            if (this.day == comparedSimpleDate.day &&
                    this.month == comparedSimpleDate.month &&
                    this.year == comparedSimpleDate.year) {
                return true;
            }

            // otherwise the objects are not equal
            return false;
        }
    }

    // Object equality and lists
ArrayList<Bird> birds = new ArrayList<>()
    Bird red = new Bird("Red");birds.add(red);birds.contains(red) // true
    red=new Bird("Red");birds.contains(red) // false, When the program switches the red object into a new object,
    // with exactly the same contents as before, it is no longer equal to the object
    // on the list

    public class Bird {
        private String name;

        public Bird(String name) {
            this.name = name;
        }

        public boolean equals(Object compared) {
            // if the variables are located in the same position, they are equal
            if (this == compared) {
                return true;
            }

            // if the compared object is not of type Bird, the objects are not equal
            if (!(compared instanceof Bird)) {
                return false;
            }

            // convert the object to a Bird object
            Bird comparedBird = (Bird) compared;

            // if the values of the object variables are equal, the objects are, too
            return this.name.equals(comparedBird.name);
        }
    }
```


// Object as a method's return value
```java
public class Counter {
    private int value;

    // example of using multiple constructors:
    // you can call another constructor from a constructor by calling this
    // notice that the this call must be on the first line of the constructor
    public Counter() {
        this(0);
    }

    public Counter(int initialValue) {
        this.value = initialValue;
    }

    public Counter clone() {
        // create a new counter object that receives the value of the cloned counter as
        // its initial value
        Counter clone = new Counter(this.value);

        // return the clone to the caller
        return clone;
    }
}

public class Factory {
    private String make;

    public Factory(String make) {
        this.make = make;
    }

    public Car procuceCar() {
        return new Car(this.make);
    }
}
```

// objects-within-objects
```java
public class Playlist {
    private ArrayList<String> songs;

    public Playlist() {
        this.songs = new ArrayList<>();
    }
}
```

```java
public class AmusementParkRide {
    private String name;
    private int minimumHeigth;
    private int visitors;
    private ArrayList<Person> riding;

    public AmusementParkRide(String name, int minimumHeigth) {
        this.name = name;
        this.minimumHeigth = minimumHeigth;
        this.visitors = 0;
        this.riding = new ArrayList<>();
    }
//Printing an Object from a List
    public String toString() {
        if (riding.isEmpty()) {
            return "no one is on the ride.";
        }

        // we form a string from the people on the list
        String peopleOnRide = "";

        for (Person person: riding) {
            peopleOnRide = peopleOnRide + person.getName() + "\n";
        }

        return "on the ride:\n" + peopleOnRide;
    }
//Clearing an Object's List
    public void removeEveryoneOnRide() {
        this.riding.clear();
    }
//Calculating a Sum from Objects on a List
    public double averageHeightOfPeopleOnRide() {
        if (riding.isEmpty()) {
            return -1;
        }

        int sumOfHeights = 0;
        for (Person per: riding) {
            sumOfHeights += per.getHeight();
        }

        return 1.0 * sumOfHeights / riding.size();
    }
//Retrieving a Specific Object from a List
    public Person getTallest() {
        // return a null reference if there's no one on the ride
        if (this.riding.isEmpty()) {
            return null;
        }

        // create an object reference for the object to be returned
        // its first value is the first object on the list
        Person returnObject = this.riding.get(0);

        // go through the list
        for (Person prs: this.riding) {
            // compare each object on the list
            // to the returnObject -- we compare heights
            // since we're searching for the tallest,

            if (returnObject.getHeight() < prs.getHeight()) {
                // if we find a taller person in the comparison,
                // we assign it as the value of the returnObject
                returnObject = prs;
            }
        }

        // finally, the object reference describing the
        // return object is returned
        return returnObject;
    }
}
// Printing an Object from a List
```