package sandbox.springstandardexception;

public class FlightInfo {

    @Min(1)
    private long id;

    private String from;

    private String to;

    private String gate;

    // getters...
}
