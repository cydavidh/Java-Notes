# Packages used to organize classes

In a library application, you might have several packages to organize your classes based on their responsibilities. Here are some examples:

1. `library.ui`:  classes that handle the rendering of the library catalog or the borrower's account information.

2. `library.data`: classes that handle data access and storage. e.g. classes that interact with a database to store and retrieve information about books and borrowers.

3. `library.services`: This package could contain classes that implement business logic. For example, it might include a `BorrowingService` class that handles the logic of borrowing and returning books.

4. `library.utils`: This package could contain utility classes that provide common functionality used across the application. For example, it might include a `DateUtils` class for handling date-related operations.

5. `library.exceptions`: This package could contain custom exception classes that represent specific error conditions in the library application.

6. `library.domain`: classes that represent the core business concepts or entities in the library system. For example, it might include classes like `Book`, `Borrower`, `Librarian`, etc. These classes typically encapsulate both data and behavior related to these concepts.

Remember, the way you structure your packages can depend on the specific needs and complexity of your application. The goal is to keep related classes together and separate classes with different responsibilities, which makes the code easier to understand and maintain.

----------------------------------------------

## Problem Space
**Definition**: set of all problems a software addresses.
**Example**: in a library management system, the problem space includes *managing books*, *tracking borrowers*, *handling book loans and returns*, etc.

## Domain
**Definition**: The area of knowledge or activity that a software application is built for. It's the specific field or industry that the software is designed to serve.
**Example**: In a library management system, the domain is *library management*.

## Concepts of the Problem Domain
**Definition**: The key ideas or entities that are part of the problem space. These are the things that the software needs to model or manage in order to address the problems it's designed to solve.
**Example**: In the library management system, the concepts of the problem domain would include things like *books*, *borrowers*, *librarians*, *loans*, *returns*, etc.

-----------------------------------------------

# import library.domain.book 

```java
package library;

public class Program {

    public static void main(String[] args) {
        System.out.println("Hello packageworld!");
    }
}
```

```java
package library.domain;

public class Book {
    private String name;

    public Book(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }
}
```

```java
package library;

import library.domain.Book;

public class Program {

    public static void main(String[] args) {
        Book book = new Book("the ABCs of packages!");
        System.out.println("Hello packageworld: " + book.getName()); 
        //Hello packageworld: the ABCs of packages!
    }
}
```