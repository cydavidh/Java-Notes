package n08_oop.heartRate;

public class Main {
    public static void main(String[] args) {

        Fitbyte fitbyte = new Fitbyte(30, 60);

        double percentage = 0.5;

        while (percentage < 1.0) {
            System.out.println(percentage);
            double target = fitbyte.targetHeartRate(percentage);
            System.out.println("Target " + (percentage * 100) + "% of maximum: " +
                    target);
            percentage += 0.1;
        }
        // output
        // Target 50.0% of maximum: 122.48500000000001
        // Target 60.0% of maximum: 134.98200000000003
        // Target 70.0% of maximum: 147.479
        // Target 80.0% of maximum: 159.976
        // Target 89.99999999999999% of maximum: 172.473
        // Target 99.99999999999999% of maximum: 184.97000000000003
        // You can't represent all decimal fractions correctly in binary.
        // Use integers to do these operations, or handle the rounding yourself.
        // Because floats and doubles cannot accurately represent the base 10 multiples
        // that we use for money.
        // This issue isn't just for Java, it's for any programming language that uses
        // base 2 floating-point types.
        // https://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency
        // https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html
    }
}
