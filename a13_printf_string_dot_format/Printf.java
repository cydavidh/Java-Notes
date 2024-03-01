package n13_printf_string_dot_format;

//https://alvinalexander.com/programming/printf-format-cheat-sheet/
public class Printf {
    public static void main(String[] args) {


        System.out.printf("Hello, %s. You owe me $%.2f.%n", "Jack", 25.0);
        // Hello, Jack. You owe me $25.00.      
        //%.2f means floating point number with 2 decimal places
        //%n means newline
        //%d means integer number
        //%s means string
        //%f means floating point number
        //%t means date/time
        //%b means boolean
        //%c means character
        //%i means integer

        //%<flags><width><.precision>specifier

        int x = 10;

        System.out.printf("%3d", 5); //'  5'

        System.out.printf("%03d", 1); //'001'
        

        System.out.printf("Formatted output is: %d %d %n", x, -x)
        // Formatted output is: 10 -10

        float z = 3.147293165f;
        System.out.printf("Precision formatting upto 2 decimal places %.2f\n",z)
        //Precision formatting upto 2 decimal places 3.15

        System.out.printf("'%5.2f'%n", 2.28);
        // ' 2.28'

        String variable = "example";

        String string = String.format("A string %s", variable);
        String str = "First %s, then %s".formatted("foo", "bar");     

        String.format("%d people are %s", 3, "chasing"); // 3 people are chasing
    }
}

/**
 * %n newline
 * %c character
 * %d decimal (integer) number (base 10)
 * %e exponential floating-point number
 * %f floating-point number
 * %i integer (base 10)
 * %o octal number (base 8)
 * %s String
 * %u unsigned decimal (integer) number
 * %x number
 * 
 * in hexadecimal (base 16)
 * %t formats date/time
 * %% print a percent sign
 * 
 * 
 * \% print a percent sign
 * \b backspace
 * \f next line first character starts to the right of current line last
 * character
 * \n newline
 * \r carriage return
 * \t tab
 * \\ backslash
 */