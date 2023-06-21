// https://blog.hubspot.com/website/static-method-java

// The static method and variable basically belong to the class, instead of a specific object created out of the class.

package n14_static;

public class CrewMember {
    public CrewMember() {
    };

    public static void introduce() {
        System.out.println("Hi, my name is John.");
    }
}

public class Program {
    public static void main(String[] args) {
        CrewMember.introduce();
        // Hi, my name is John.
    }
}

// =============================================================================================================

public class Counter {
    public static int count = 0;

    Counter() {
        count++;
    }
}

public class MyClass {
    public static void main(String[] args) {
        Counter c1 = new Counter(); // count++
        Counter c2 = new Counter(); // count++
        System.out.println(Counter.count); // 2
    }
}

// The COUNT variable will be shared by all objects of that class.
// When we create objects of our Counter class in main, and access the static
// variable.

public class MyClass {
    public static void main(String[] args) {
        Counter c1 = new Counter();
        Counter c2 = new Counter();
        System.out.println(Counter.COUNT);
    }
}
// Outputs "2"
// The outout is 2, because the COUNT variable is static
// and gets incremented by one each time a new object of the Counter class is
// created.
// You can also access the static variable using any object of that class, such
// as c1.COUNT.