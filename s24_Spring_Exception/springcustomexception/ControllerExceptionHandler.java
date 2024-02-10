package sandbox.springcustomexception;

import java.time.LocalDateTime;

@ControllerAdvice
public class ControllerExceptionHandler {

    @ExceptionHandler(FlightNotFoundException.class) // this method can also be in the controller class.
    public ResponseEntity<CustomErrorMessage> handleFlightNotFound(
            FlightNotFoundException e, WebRequest request) {

        CustomErrorMessage body = new CustomErrorMessage(
                HttpStatus.NOT_FOUND.value(),
                LocalDateTime.now(),
                e.getMessage(),
                request.getDescription(false));

        return new ResponseEntity<>(body, HttpStatus.NOT_FOUND);
    }
}
