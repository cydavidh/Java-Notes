# two ways to return ResponseEntity: both return new instance, one with constructor, another with methods.

https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/ResponseEntity.html#field-summary
https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/ResponseEntity.BodyBuilder.html

```java
@RestController
public class ApiController {
    @GetMapping("/api/health")
    public ResponseEntity<String> health() {
        return new ResponseEntity<>("OK", HttpStatus.OK); // returns a new instance (with a body of String "OK") by using the ResponseEntity constructor
    }

    @GetMapping("/api/qrcode")
    // return 501 Not Implemented
    public ResponseEntity<String> qrcode() {
        return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).body("Not Implemented"); 
        // uses ResponseEntity.status() to create a BodyBuilder instance and then calls body() to create the ResponseEntity instance
        /*The method call ResponseEntity.status(501) creates an instance of ResponseEntity.BodyBuilder. 
        This BodyBuilder is then used to set up various parts of the response entity. 
        When the .body("Not Implemented") method is called on this BodyBuilder, 
        it completes the building process and creates an instance of ResponseEntity<String> with the specified status and body. */
        return ResponseEntity.ok().contentType(mediaType).body(bufferedImage);
        return ResponseEntity.ok(cinemaService.getStats());
    }
}

```