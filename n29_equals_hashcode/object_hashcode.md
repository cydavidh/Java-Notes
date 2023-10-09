java in a nutshell p.133

#java.lang.Object
- when override Object.equals(), must also override Object.hashCode().
- hashCode() method returns an integer for use by hash table data structures.
- two objects need to have same hashcode if they are equal according to equals() mthod.


For a class to be used as a HashMap's key, we need to define for it:
1 the equals method, so that all equal or approximately equal objects cause the comparison to return true and all false for all the rest
2 the hashCode method, so that as few objects as possible end up with the same hash value

hashcode and equals method all belong to the object/class, not the hashmap class.

hashcode example:  java in a nutshell p.131

```java
public class Circle implements Comparable<Circle> {
    private final int x, y, r;

    public Circle(int x , int y, int r) {
        if (r < 0) throw new IllegalArguementException("negative radius");
        this.x = x; this.y = y; this.r = r;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) return true;     // Identical references?

        if (!(o instanceof Circle)) return false;   // Correct type and non-null?

        Circle that = (Circle) o        // Cast to our type. 
                                        // "public boolean  equals(Circle o)" won't work for 
                                        // "Object circle1 = new Circle(1,2,3)"
        
        if (this.x == that.x && this.y == that.y && this.r == that.r) // If x,y,r are object reference variables like Strings, use .equals() instead.
            return true;
        else
            return false;
    }

    //Another reason equals(Circle o) won't work
        Object r = new Rational();
        boolean b = r.equals("x");
        @Override public boolean equals(Rational o) {}
    // If your override had worked, you'd now have a Rational reference to a String object - madness! 
    // That would break the type-safety rules in Java. By forcing your args to be an exact match, the language can ensure that only "acceptable" arguments appear in the method.

    @Override public int hashCode() { //hash code algorithm from Effective Java by Joshua Bloch
        int result = 17;
        result = 37*result + x; 
        result = 37*result + y;
        result = 37*result + r;
        return result;
    }

    // two objects must have same hash code if they are equals according to the equals() method.
    // important but not required for unequal object to have unequal hash codes
    // when you override equals(), you must always override hashCode() to guarantee that equal objecct have equal hash codes.
    // since Circle.equals() compares values of 3 fields, hashcode also three.
    // Note that the hashCode() above does not simply add three fields together and return sum,
    // legal but not efficient because if two circle with x and y reversed would have same hashcode
    // repeated multiplication and addition steps "spread out" the range of hash code and dramatically reduce likelihood two unequal Circle objects have the same hash code.
}
```