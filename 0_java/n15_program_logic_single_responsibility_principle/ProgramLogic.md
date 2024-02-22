Single Responsibility Principle

# Original Program
```java
Program{
    new scanner
    new ArrayList<Integer> grades

    score = input

    score 50 then grade F
    score 60 then grade E
    70 -> D
    80 -> C
    90 -> B
    100 -> A

    grades arraylist add grade

    for loop 5 to 0
        for loop grades arraylist
            if grade == i
            stars++
        print stars

}
```
<!--
Points: 55
Points: 51
Points: 49
Points: 48
Points:

A: ***
B: **
C: *
D:
E: ***
F: **
-->

# seperate grades

```java

Program {
    new scanner
    new GradeRegister register

    read input points using while true

    register.pointsToGradeToGradesArrayList(points)

    for loop 5 to 0
        stars = register.numberOfEachGrades(5 to 0)
        print stars

}

GradeRegister {
    private ArrayList grades
    constructor

    int numberOfEachGrades(int inputGrade 0-5) {
        loop grades ArrayList to find total number of occurence for inputGrade 0-5 //F to A.
    }

    int pointsToGrade(points) {
        score 50 -> grade F
        return grade;
    }

    void pointsToGradeToGradesArrayList(int points) {
        this.gradesArrayList.add(pointsToGrade(points))
    }

    //I don't know why not just combine the above two methods.
    //I guess it makes the method more simple and unifucntional.

}

```
# seperate user interface

```java
Program {
    new Scanner
    new GradeRegister register
    new UserInterface(register, scanner)

    main{
        userInterface start();
    }
}

UserInterface {
    private GradeRegister register
    private Scanner scanner

    constructor(GradeRegister register, Scanner scanner)

    start() {
        readPoints();
        printGradeDistribution();
    }

    readPoints() {
        read input points using while true
        this.register.addGradeBasedOnPoints(points);
    }

    printGradeDistribution() {
        for loop 5 to 0
            stars = register.numberOfEachGrades(5 to 0)
            printStars()
    }

    printStars(int stars) {
        print stars
    }

}

GradeRegister {
    same from above
}


```