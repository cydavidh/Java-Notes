```java
import java.util.List;
public class Statistics {
    private List<Integer> numbers;
    public void add(int number) {
        this.numbers.add(number);
    }
    public double average() {
        return this.numbers.stream().mapToInt(i -> i).average().getAsDouble();
    }
}
public class Program{
    public static void main(String[] args) {
        Statistics st = new Statistics();
        System.out.println("Printing the average of the statistics: " + st.average());
        System.out.println("Adding number 22");
        st.add(22);
        System.out.println("Printing the average of the statistics: " + st.average());
    }
}
```


There are two problems:s

First the NullPointerException is thrown at runtime by the Java Virtual Machine (JVM) because the list number is null as it is declared but not initialized.

getAsDouble() throws NoSuchElementException if no value is present, so we need to use a try catch block to handle this exception.