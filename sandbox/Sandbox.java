package sandbox;

import java.util.Scanner;

_

class Animal {
    
    _ String name;
       public Animal(String name) {
           this.name = name;
       }
       public String getName() {
           return name;
       }
   }


public class Dog
_ Animal
{
    private String breed;

    public Dog(String name, String breed) {
        _(name);
        this.breed = breed;
    }

    public String getBreed() {
        return breed;
    }
}
