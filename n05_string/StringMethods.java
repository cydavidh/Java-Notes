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
        name1.indexOf('e'); // returns 3, -1 if not found
        name1.charAt(0); // returns 'c'
        name1.toCharArray(); // returns a char[] that contains the string
        char[] test = name1.toCharArray();
        name1.isEmpty(); // returns false
        name1.startsWith("che"); // returns true
        name1.contains("tshe"); // returns true
        test.toString();
        name1.replace(int1, int2, "String");
        // Change chars from pos1 to pos2 by string

        // split
        String input = "David, 26";
        String[] pieces = input.split(",");
        System.out.println("Name: " + pieces[0] + ", age: " + pieces[1]);

        // why use String.equals() instead of ==
        String string1 = "MYTEXT";
        String string2 = new String("MYTEXT");
        System.out.println(string1 == string2); // false

        String string3 = "MYTEXT";
        String string4 = new String(string1);
        System.out.println(string3 == string4); // false
    }
}
