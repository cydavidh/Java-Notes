package n05_string;

public class StringMethods {
    public static void main(String[] args) {

        String name1 = "cheatsheet";
        String name2 = "exam";
        name1.length(); // unlike array.length no parenthesis or arraylist.size()
        "1,000,000".replace(",", "");
        name2.concat(name1);
        name1.equals("cheatsheet");
        name1.equalsIgnoreCase(name2);
        name1.indexOf('e');
        name1.charAt(0);
        name1.toCharArray();
        name1.isEmpty();
        name1.contains("tshe");
        char[] test = name1.toCharArray();
        test.toString();
        name1.replace(int1, int2, "String");
        // Change chars from pos1 to pos2 by string

        // split
        String input = "David, 26";
        String[] pieces = input.split(",");
        System.out.println("Name: " + pieces[0] + ", age: " + pieces[1]);
    }
}
