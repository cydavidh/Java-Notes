package sandbox.springstandardexception;

@RestController
public class FlightController {

    private final List<FlightInfo> flightInfoList = Collections.synchronizedList(
            new ArrayList<>());

    // constructor

    // getFlightInfo method

    @PostMapping("/flights/new")
    public void addNewFlightInfo(@Valid @RequestBody FlightInfo flightInfo) {
        flightInfoList.add(flightInfo);
    }
}
