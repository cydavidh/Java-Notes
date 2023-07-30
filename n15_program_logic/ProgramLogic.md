# Original Program

<!--
Points: 55
Points: 51
Points: 49
Points: 48
Points:

5: ***
4: **
3: *
2:
1: ***
0: **
-->

Program{
new scanner
new ArrayList<Integer> grades

    score = input

    score 50 then grade 0
    score 60 then grade 1
    70 -> 2
    80 -> 3
    90 -> 4
    100 -> 5

    grades arraylist add grade

    for loop 5 to 0
        for loop grades arraylist
            if grade == i
            stars++
        print stars

}

# seperate grades

GradeRegister {
private ArrayList grades
constructor

    int numberOfEachGrades(int inputGrade 0-5) {
        loop grades ArrayList to find total number of occurence for inputGrade 0-5.
    }

    int pointsToGrade(points) {
        score 50 -> grade 0
        return grade;
    }

    void pointsToGradeToGradesArrayList(int points) {
        this.gradesArrayList.add(pointsToGrade(points))
    }

    //I don't know why not just combine the above two methods.
    //I guess it makes the method more simple and unifucntional.

}

Program {
new scanner
new GradeRegister register

    read input points using while true

    register.pointsToGradeToGradesArrayList(points)

    for loop 5 to 0
        stars = register.numberOfEachGrades(5 to 0)
        print stars

}

# seperate user interface

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

Program {
new Scanner
new GradeRegister register
new UserInterface(register, scanner)

    userInterface start();

}
