package n38_upcast_downcast_polymorphism;

public class UpcastDowncast {
    public static void main(String[] args) {
        UpcastDowncast main = new UpcastDowncast();
        Person personActuallyMale = main.new Male(); // Upcast
        Male male = (Male) personActuallyMale; // Downcast
        Kid kid = (Kid) male; // Downcast failed, because Male object is not a Kid object.

        Person davidPerson = main.new Person(); // each object instance of a different class.
        Person davidMale = main.new Male(); // we create new instance of Male class and upcast it to Person object.
        // even though the variable type is Person, the instance assigned to it is
        // actually an instance of the Male class.
        Person davidKid = main.new Kid();
        davidPerson.speak(); // I am a person
        davidMale.speak(); // I am a male
        davidKid.speak(); // I am a kid

    }

    public class Person {
        public void speak() {
            System.out.println("I am a person");
        }
    }

    public class Male extends Person {
        public void speak() {
            System.out.println("I am a male");
        }
    }

    public class Kid extends Male {
        public void speak() {
            System.out.println("I am a kid");
        }
    }
}
