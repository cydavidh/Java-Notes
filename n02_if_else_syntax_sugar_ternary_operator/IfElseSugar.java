package n02_if_else_syntax_sugar_ternary_operator;

public class IfElseSugar {

    public static void main(String[] args) {
        // variable = (condition) ? expressionTrue : expressionFalse;
        int time1 = 20;
        String result = (time1 < 18) ? "Good day!" : "Good evening!";
        System.out.println(result); // Outputs "Good evening!"



        String someStrong = "Hello, World!";

        int length = someStrong == null ? 0 : someStrong.length();
        System.out.println(length);

        System.out.println(someStrong == null ? 0 : someStrong.length());
    }
}
