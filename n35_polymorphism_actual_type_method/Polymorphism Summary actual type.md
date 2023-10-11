Polymorphism means an entity performing different operations depending on the scenario.
This entity could be method, operator, or object. 
Examples of polymorphism are: method overloading, method overriding, and operator overloading.
In the case of this chapter, we first see the practice of storing/assigning a Child (Student) reference to an object of the Parent (Person) type. 
This offers the unique benefit of having consistent code across the parent class and subclasses. 
That is, a single method (toString) that will behave differently depending on the instance of the class that is assigned to the object.

Person david = new Male(); 
// we create new instance of Male class and upcast it to Person object.
// even though the variable type is Person, the instance assigned to it is
// actually an instance of the Male class.