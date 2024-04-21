package cydavidh.springdemo.p09exception;

public class FlightInfo {

    private int id;
    private String from;
    private String to;
    private String gate;

    // constructor
    public FlightInfo(int id, String from, String to, String gate) {
        this.id = id;
        this.from = from;
        this.to = to;
        this.gate = gate;
    }

    // getters and setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public String getGate() {
        return gate;
    }

    public void setGate(String gate) {
        this.gate = gate;
    }
}
