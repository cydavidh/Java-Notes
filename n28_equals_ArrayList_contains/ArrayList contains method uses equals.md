The == operator tests two references to see if they refer to the same object.
Object.equals() method simply uses the == operator: this default method considers two objects equal only if they are actually the very same object with same references.


If Book does not have an overriding equals method.
```java
ArrayList Books;
Book book = new Book(name1, year1, content1)
ArrayList.add(Book)

books.contains(book) //true, uses default Object equals to compare reference

book = new Book(name1, year1, content1)

books.contains(book) //false, since the line 4 book that was added to arraylist was not the same reference as line 9 book


```


If Book does have equals method.
```java
ArrayList Books;
Book book = new Book(name1, year1, content1)
ArrayList.add(Book)

books.contains(book) //true, uses overide Books equals to compare name, year, content

book = new Book(name1, year1, content1)

books.contains(book) //true, uses overide Books equals to compare name, year, content
```