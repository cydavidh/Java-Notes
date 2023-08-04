Definition.

- wrapping the data (variables) and code acting on the data (methods) together as a single unit.
- variables of a class will be hidden from other classes, and can be accessed only through the methods of their current class.
- also known as data hiding.

To achieve encapsulation in Java −

1 Declare the variables of a class as private.

2 Provide public setter and getter methods to modify and view the variables values.

#Following is an example that demonstrates how to achieve Encapsulation in Java −

/_ File name : EncapTest.java _/
      public class EncapTest {
      private String name;
      private String idNum;
      private int age;

      public int getAge() {
      return age;
      }

      public String getName() {
      return name;
      }

      public String getIdNum() {
      return idNum;
      }

      public void setAge( int newAge) {
      age = newAge;
      }

      public void setName(String newName) {
      name = newName;
      }

      public void setIdNum( String newId) {
      idNum = newId;
      }

}

#The public setXXX() and getXXX() methods are the access points of the instance variables of the EncapTest class. Normally, these methods are referred as getters and setters. Therefore, any class that wants to access the variables should access them through these getters and setters.

The variables of the EncapTest class can be accessed using the following program −

/_ File name : RunEncap.java _/
public class RunEncap {

      public static void main(String args[]) {
            EncapTest encap = new EncapTest();
            encap.setName("James");
            encap.setAge(20);
            encap.setIdNum("12343ms");
            System.out.print("Name : " + encap.getName() + " Age : " + encap.getAge());
      }
}
