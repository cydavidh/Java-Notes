package n10_overloading_constructor_or_methods;

public class Main {
    public static void main(String[] args) {
        Person paul = new Person("Paul", 24);
        Person ada = new Person("Ada");

        System.out.println(paul);
        System.out.println(ada);

        // Paul is 24 years old.
        // Eve is 0 years old.

        Person daniel = new Person("Daniel", 24);
        System.out.println(daniel);

        daniel.growOlder();
        System.out.println(daniel);

        daniel.growOlder(10);
        System.out.println(daniel);

        // Paul is 24 years old.
        // Paul is 25 years old.
        // Paul is 35 years old.
    }
}
