package n02_if_else_syntax_sugar;

public class IfElseSugar {
    public static void main(String[] args) {
        // variable = (condition) ? expressionTrue : expressionFalse;
        int time1 = 20;
        String result = (time1 < 18) ? "Good day!" : "Good evening!";
        System.out.println(result);// Outputs "Good evening!"
    }
}
