Polymorphism means an entity performing different operations depending on the scenario.
This entity could be method, operator, or object. 
Examples of polymorphism are: subtyping polymorphism, method overloading, method overriding, and operator overloading.

In the case of this chapter, we first see the practice of storing/assigning a Child (Student) reference to an object of the Parent (Person) type. 
This offers the unique benefit of having consistent code across the parent class and subclasses. 
That is, a single method (toString) that will behave differently depending on the instance of the class that is assigned to the object.

Person david = new Male(); 
// we create new instance/object of Male class and upcast it to Person object.
// even though the object's class (i.e. its type) is Person, 
// the instance/object assigned to it is actually an instance/object of the Male class.

Upcasting is an example of implicit or widening reference conversion, which is a form of polymorphism known as subtyping polymorphism or inclusion polymorphism.

Subtyping polymorphism allows a subclass to be treated as an instance of its superclass. In the case of upcasting, we are treating an instance of a subclass as an instance of its superclass. This is possible because the subclass inherits all the properties and behaviors of its superclass, and can therefore be used in any context where the superclass is expected.