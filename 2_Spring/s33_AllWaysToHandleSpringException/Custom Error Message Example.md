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
I create custom error message
```java
import java.time.LocalDateTime;

public class CustomErrorMessage {
    private int statusCode;
    private LocalDateTime timestamp;
    private String message;
    private String description;

    public CustomErrorMessage(
            int statusCode,
            LocalDateTime timestamp,
            String message,
            String description) {

        this.statusCode = statusCode;
        this.timestamp = timestamp;
        this.message = message;
        this.description = description;
    }

    // getters ...
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
