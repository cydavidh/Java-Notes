import java.util.ArrayList;

public class Box implements Packable {
    private double capacity;
    private ArrayList<Packable> packables;

    public Box(double capacity) {
        this.capacity = capacity;
        this.packables = new ArrayList<>();
    }

    public void add(Packable packable) {
        if (packable.weight() <= capacity - weight()) {
            packables.add(packable);
        }
    }

    public double weight() {
        double weight = 0;
        // calculate the total weight of the items in the box
        for (Packable packable : packables) {
            weight += packable.weight();
        }
        return weight;
    }

    public String toString() {
        // Box: 6 items, total weight 4.0 kg
        return "Box: " + packables.size() + " items, total weight " + weight() + " kg";
    }

}
