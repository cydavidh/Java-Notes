ResponseStatusException

```java
ResponseStatusException(HttpStatus status)
ResponseStatusException(HttpStatus status, java.lang.String reason)
ResponseStatusException(
        HttpStatus status, 
        java.lang.String reason, 
        java.lang.Throwable cause
)
```
```java
@GetMapping("flights/{id}")
public FlightInfo getFlightInfo(@PathVariable int id) {
    for (FlightInfo flightInfo : flightInfoList) {
        if (flightInfo.getId() == id) {
            if (Objects.equals(flightInfo.getFrom(), "Berlin Schönefeld")) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,  //over here bro look here
                        "Berlin Schönefeld is closed for service today");
            } else {
                return flightInfo;
            }
        }
    }

    throw new RuntimeException();
}
```


Custom Exceptions

```java
@ResponseStatus(code = HttpStatus.BAD_REQUEST)
class FlightNotFoundException extends RuntimeException {
    
    public FlightNotFoundException(String message) {
        super(message);
    }
}
```
```java
@GetMapping("flights/{id}")
public FlightInfo getFlightInfo(@PathVariable int id) {
    for (FlightInfo flightInfo : flightInfoList) {
        if (flightInfo.getId() == id) {
            return flightInfo;
        }
    }

    throw new FlightNotFoundException("Flight not found for id =" + id);
}
```
