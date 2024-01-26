final for Reference variables means that it is not possible to reassign a reference to the variable.

final String string = new String();
string = new String(); //error


final String string = new String();
string.append("hello");
// string gos from "" to "hello"