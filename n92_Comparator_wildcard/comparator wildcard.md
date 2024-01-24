`Collections.sort(List<T> list, Comparator<? super T> c)`

`Collections.sort(dogs, new AnimalAgeComparator());` // AnimalAgeComparator implements Comparator<Animal>

Basically
Collections.sort(List<Dog> listOfDogs, Comparator<Animal super Dog>)
? is Animal
which is superclass of
T is Dog


```java
class Animal {
    int age;
    // Constructor, getters, setters
}

class Dog extends Animal {
    // Dog specific code
}

class AnimalAgeComparator implements Comparator<Animal> {
    @Override
    public int compare(Animal a1, Animal a2) {
        return Integer.compare(a1.getAge(), a2.getAge());
    }
}

// ... in your main method or other method:
List<Dog> dogs = new ArrayList<>();
dogs.add(new Dog(5));
dogs.add(new Dog(3));
dogs.add(new Dog(8));

Collections.sort(dogs, new AnimalAgeComparator());
```