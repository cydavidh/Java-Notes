
Varargs (Variable Arguments) in Java allow a method to accept a variable number of arguments. Varargs are used when you don't know how many arguments a method will need to handle. It's defined in a method signature with the syntax Type... parameterName.

legal
```
void doStudd(int... x) {} //0 to many ints
void doStudd(char c, int... x) {} // first a char, then 0 to many ints
void doStudd(Animal...animals) {} // 0 to many animals
```

```java
void doStuff(int x...) {} //wrong syntax
void doStuff(int... x, char... y) {} //to many varargs
void doStuff(int... x, byte b) {} //var-arg must be last
```



```java
public static void printNumbers(int... numbers)
```

```java
printNumbers(1, 2, 3, 4, 5);  // Call with multiple arguments
printNumbers(10);             // Call with one argument
printNumbers(new int[19]); //you can invoke the method by passing several integer numbers or an array of ints.
printNumbers(new int[] { }); // no arguments here
printNumbers(new int[] { 1, 2 });
```

