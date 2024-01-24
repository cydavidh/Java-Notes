# Scanner(System.in)
```java
Scanner scanner = new Scanner(System.in);

String string = scanner.nextLine();
int integer = Integer.valueOf(scanner.nextLine());
double floatingPoint = Double.valueOf(scanner.nextLine());
boolean trueOrFalse = Boolean.valueOf(scanner.nextLine());
int integer = Integer.valueOf(string);
int integer = scanner.nextInt(); //cannot be empty //.nextInt() call is just not going to return until an actual number of some sort is entered (or, if something else is submitted by the user, the InputMismatchException occurs instead.
```
==============================================================================================
# scanner.next()
```java
System.out.print("Enter full name: ");        
Scanner scan = new Scanner(System.in);  //a b c
String a = scan.next();  
String b = scan.next();  
String c = scan.next();  
System.out.println(a + b + c); //abc  

```
==============================================================================================
# Scanner(input)
```java
String input = "one\n" + "two\n" + "three\n";
Scanner reader = new Scanner(input);
System.out.println(reader.nextLine()); // one
System.out.println(reader.nextLine()); // two
```

==============================================================================================

Try with Resources Scanner

```java
try (Scanner scanner = new Scanner(System.in)) {
    int input = Integer.valueOf(scanner.nextLine());
} catch (NumberFormatException e) {
    System.out.println("Invalid input. Please enter a number.");
}
```