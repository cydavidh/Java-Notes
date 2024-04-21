package sandbox.springcustomexception;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@RestController
public class FlightController {

    private final List<FlightInfo> flightInfoList = Collections.synchronizedList(
            new ArrayList<>());

    public FlightController() {
        flightInfoList.add(
                new FlightInfo(
                        1,
                        "Delhi Indira Gandhi",
                        "Stuttgart",
                        "D80"));
        flightInfoList.add(
                new FlightInfo(
                        2,
                        "Tokyo Haneda",
                        "Frankfurt",
                        "110"));
    }

    @GetMapping("flights/{id}")
    public FlightInfo getFlightInfo(@PathVariable long id) {
        for (var flightInfo : flightInfoList) {
            if (flightInfo.getId() == id) {
                return flightInfo;
            }
        }

        throw new FlightNotFoundException("Flight info not found id=" + id);
    }
}
