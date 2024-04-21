package n10_overloading_constructor_or_methods;

public class Person {
    private String name;
    private int age;
    private int height;
    private int weight;

    public Person(String name) {
        this.name = name;
        this.age = 0;
        this.weight = 0;
        this.height = 0;
    }

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
        this.weight = 0;
        this.height = 0;
    }

    public void growOlder() {
        this.age = this.age + 1;
    }

    public void growOlder(int years) {
        this.age = this.age + years;
    }
}
