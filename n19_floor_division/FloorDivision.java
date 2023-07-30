package n19_floor_division;

public class FloorDivision {
    public static void main(String[] args) {
        System.out.println(3 / 2); // output is 1
        // in java division is already like python floor division
        // except it rounds towards zero for negatives.
        // 4/-3 = -1.3333
        System.out.println(4 / -3); // output is -1
        System.out.println(Math.floorDiv(4, -3)); // output is -2

        int i = (int) Math.ceil(9 / 2.0); // needs to be 2.0 because otherwise 9/2 is 4, and Math.ceil(4) is useless
        System.out.println(i);
    }
}