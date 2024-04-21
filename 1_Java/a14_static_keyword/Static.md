At the start of the course, all of our methods included the "static" modifier,
but when we started using objects, use of the "static" modifier was banned.

Methods in Java can be divided into two groups, based on whether they have the "static" modifier or not.
Methods without the "static" modifier are instance methods.
Methods with the "static" modifier are class methods

Instance methods are methods that are associated with an object,
can process the objects variables and can call the object's other methods.
Instance methods specifically CAN use the "this" modifier,
which refers to the variables associated with the specific object,
that is calling the instance method.
Class methods can't use the "this" modifier,
meaning that they can only access the variables they are given as parameters or that they create themselves.

In reality class methods can also access class variable, among other things.
However, these things are outside the scope of this course.
