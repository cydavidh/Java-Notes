

```java
do {
    // code to be executed
} while (condition);
```

====================================================================================================
Do `roll dice` while `roll NOT 6`

```java
import java.util.Random;

public class Main {
    public static void main(String[] args) {
        Random rand = new Random();
        int roll;



        do {
            roll = rand.nextInt(6) + 1;
            System.out.println("You rolled: " + roll); // You rolled: 3
        } while (roll != 6);




        System.out.println("You rolled a 6! You win!");
    }
}
```

====================================================================================================

Other examples


```java
int count = 0;
do {
    System.out.println("Count is: " + count);
    count++;
} while (count < 5);
```

```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int number;
        do {
            System.out.println("Enter a positive number:");
            while (!scanner.hasNextInt()) {
                String input = scanner.next();
                System.out.printf("\"%s\" is not a valid number.\n", input);
            }
            number = scanner.nextInt();
        } while (number <= 0);
        System.out.printf("You have entered a positive number: %d.\n", number);
    }
}
```

