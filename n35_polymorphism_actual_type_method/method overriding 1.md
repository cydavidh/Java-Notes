If a reference to a Student type object is stored in a Person type variable, only the methods defined in the Person class (and its superclass and interfaces) are available:

```java
Person ollie = new Student("Ollie", "6381 Hollywood Blvd. Los Angeles 90028");
ollie.credits();        // DOESN'T WORK!
ollie.study();              // DOESN'T WORK!
System.out.println(ollie);   // ollie.toString() WORKS
```

An object (ollie) 's type (Person) decides available methods.

```java
ollie.credits();        // DOESN'T WORK!
ollie.study();              // DOESN'T WORK!
```

But, the actual type (Student) assigned to the variable decides which version of the method executes. (Student.toString)

```java
Student ollie = new Student("Ollie", "6381 Hollywood Blvd. Los Angeles 90028");
Person olliePerson = new Student("Ollie", "6381 Hollywood Blvd. Los Angeles 90028");
Object ollieObject = new Student("Ollie", "6381 Hollywood Blvd. Los Angeles 90028");
System.out.println(ollie);
System.out.println(olliePerson);
System.out.println(ollieObject);
```

Output: (all results of Student.toString)

Ollie
  6381 Hollywood Blvd. Los Angeles 90028
  credits 0
Ollie
  6381 Hollywood Blvd. Los Angeles 90028
  credits 0
Ollie
  6381 Hollywood Blvd. Los Angeles 90028
  credits 0