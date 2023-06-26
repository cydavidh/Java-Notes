# stack trace

Exception in thread "main" ...
at Program.main(Program.java:15)

# pass test input to scanner

String input = "one\n" + "two\n" +"three\n" "four\n" +"five\n" + "one\n" +"six\n";

Scanner reader = new Scanner(input);

# Unit testing

jUnit
public class CalculatorTest {

    @Test
    public void calculatorInitialValueZero() {
        Calculator calculator = new Calculator();
        assertEquals(0, calculator.getValue());
    }

}

# Test Driven Development

1. Write Test
2. Run test. Must fail. If pass, bad.
3. Write function to fulfill test requirement only.
4. Run test. If fail, fix function.
5. Refactor.

//(Refactoring means cleaning the code while maintaining the functionality of the program. Cleaning includes tasks such as improving the readibility and dividing the program into smaller methods and classes)
