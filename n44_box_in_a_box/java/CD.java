public class CD implements Packable {
    private String artist;
    private String name;
    private int year;

    public CD(String artist, String name, int year) {
        this.artist = artist;
        this.name = name;
        this.year = year;
    }

    public double weight() {
        return 0.1;
    }

    public String toString() { // Pink Floyd: Dark Side of the Moon (1973)
        return this.artist + ": " + this.name + " (" + this.year + ")";
    }
}
