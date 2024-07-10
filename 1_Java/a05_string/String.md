```java
String name1 = "cheatsheet";
String name2 = "exam";
String name 3 = new String();
name1.length(); // unlike array.length no parenthesis or arraylist.size()
"1,000,000".replace(",", "");
name2.concat(name1);
name1.equals("cheatsheet");
name1.equalsIgnoreCase(name2);
name1.indexOf('e'); // returns 3, -1 if not found
name1.charAt(0); // returns 'c'
name1.toCharArray(); // returns a char[] that contains the string
char[] test = name1.toCharArray();
name1.isEmpty(); // returns false
name1.startsWith("che"); // returns true
name1.contains("tshe"); // returns true

// two ways to convert to String
test.toString(); // returns "cheatsheet"
String.valueOf(0); // returns "0"


name1.replace(int1, int2, "String");
// Change chars from pos1 to pos2 by string

// split
String input = "David, 26";
String[] pieces = input.split(",");
System.out.println("Name: " + pieces[0] + ", age: " + pieces[1]);

// why use String.equals() instead of ==
String string1 = "MYTEXT";
String string2 = new String("MYTEXT");
System.out.println(string1 == string2); // false

String string3 = "MYTEXT";
String string4 = new String(string1);
System.out.println(string3 == string4); // false
```

loop over string

use toCharArray()
returns char[]
```java
for (char c : str.toCharArray()) {
    System.out.println(c);
}
```