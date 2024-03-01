1. ResponseEntityExceptionHandler abstract class
    - standard exception
    - custom exception
2. @ExceptionHandler
    - standard exception
    - custom exception
3. ResponseStatusException class

1. ResponseEntityExceptionHandler abstract class
    - **standard exception**
    - custom exception
```java
@ControllerAdvice
public class CustomGlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException ex,
                                                                  HttpHeaders headers,
                                                                  HttpStatus status,
                                                                  WebRequest request) {
        // Create a map to hold the errors
        Map<String, String> errors = new HashMap<>();
        for (FieldError error : ex.getBindingResult().getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }
        for (ObjectError error : ex.getBindingResult().getGlobalErrors()) {
            errors.put(error.getObjectName(), error.getDefaultMessage());
        }

        // Return a response entity with the status code and body containing the errors
        return handleExceptionInternal(ex, errors, headers, HttpStatus.BAD_REQUEST, request);
    }
}
```

1. ResponseEntityExceptionHandler abstract class
    - standard exception
    - **custom exception**
setup in controller
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
create a new custom exception class
```java
class FlightNotFoundException extends RuntimeException {
    
    public FlightNotFoundException(String message) {
        super(message);
    }
}
```
plat principal
```java
@ControllerAdvice
public class CustomResponseEntityExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(FlightNotFoundException.class)
    protected ResponseEntity<Object> handleFlightNotFound(
        FlightNotFoundException ex, WebRequest request) {
        // Constructing error response body. You could also create a more detailed error response object.
        String bodyOfResponse = ex.getMessage();
        
        // Returning a ResponseEntity with an appropriate HttpStatus and body
        return handleExceptionInternal(ex, bodyOfResponse, 
          new HttpHeaders(), HttpStatus.NOT_FOUND, request);
    }
    
    // You can add more exception handlers here if needed
}
```


2. @ExceptionHandler
    - **standard exception**
    - custom exception
```java
@ControllerAdvice
public class ValidationExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    // @ResponseStatus(HttpStatus.BAD_REQUEST) //redundant
    public ResponseEntity<Object> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach((error) -> {
            String fieldName = error.getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return ResponseEntity.badRequest().body(errors);
    }


    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException ex, WebRequest request) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", LocalDateTime.now());
        body.put("status", HttpStatus.BAD_REQUEST.value());

        // Get all errors
        List<String> errors = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(x -> x.getField() + ": " + x.getDefaultMessage())
                .collect(Collectors.toList());

        body.put("errors", errors);

        return new ResponseEntity<>(body, HttpStatus.BAD_REQUEST);
    }
}
```

2. @ExceptionHandler
    - standard exception
    - **custom exception**
I create exception class
```java
public class OutOfBoundsException extends RuntimeException  {
    public OutOfBoundsException(String message) {
        super(message);
    }
}
```
I throw this exception in controller or service
```java
public synchronized PurchaseResponse purchaseSeat(int row, int col) {
    if (row < 0 || row >= cinema.getRows() || col < 0 || col >= cinema.getCols()) {
        throw new OutOfBoundsException("The number of a row or a column is out of bounds!");
    }
}
```
I catch and handle the exception with @ExceptionHandler

```java
I catch and handle the exception with @ExceptionHandler
```java
@ExceptionHandler(OutOfBoundsException.class)
public ResponseEntity<CustomErrorMessage> handleOutOfBoundsException(OutOfBoundsException ex) {
    CustomErrorMessage errorMessage = new CustomErrorMessage(ex.getMessage());
    return new ResponseEntity<>(errorMessage, HttpStatus.BAD_REQUEST);
}
```


3. ResponseStatusException class **custom only**
throw directly in controller, very handy
```java
@RestController
public class MyController {

    @GetMapping("/some-endpoint")
    public String someEndpointMethod() {
        // Some logic that might fail
        if (someConditionFails) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Entity not found");
        }

        return "Success Response";
    }
}
```