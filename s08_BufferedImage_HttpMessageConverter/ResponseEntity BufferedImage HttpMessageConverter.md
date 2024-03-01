```java
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Map;

@RestController
public class DemoController {
    /*
    Static: This means that the images map is shared across all instances of the class it's declared in. This is useful when you want a common collection of images accessible to every instance of the class, rather than each instance having its own separate copy. It's especially common in contexts where the data is meant to be constant and shared, like a cache of resources.

    Final: This means that once the images map is initialized, it cannot be re-assigned to another object. This ensures the integrity of the map throughout the lifetime of the application. It's important to note that final only prevents reassignment of the reference, it doesn't prevent modification of the object itself. You can still add or remove entries from the map.
    */
    private static final Map<String, BufferedImage> images = Map.of( //
            "green", createImage(Color.GREEN),
            "magenta", createImage(Color.MAGENTA)
    );

    @GetMapping(path = "/image")
    public ResponseEntity<BufferedImage> getImage(@RequestParam String name,
                                                  @RequestParam String mediaType) {
        BufferedImage image = images.get(name);
        if (image == null) {
            return ResponseEntity.notFound().build(); //ResponseEntity.HeadersBuilder build() method
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(mediaType)) //ResponseEntity.BodyBuilder contentType() method
                .body(image); //put the BufferedImage in the reponse body.
    }

    private static BufferedImage createImage(Color color) {
        BufferedImage image = new BufferedImage(20, 20, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = image.createGraphics();
        g.setColor(color);
        g.fillRect(0, 0, 20, 20);
        g.dispose();

        return image;
    }
}
```

# why contentType() is in bodybuilder not headersbuilder

The contentType method is provided in the ResponseEntity.BodyBuilder and not in the ResponseEntity.HeadersBuilder in Spring framework due to the specific use case it addresses. The BodyBuilder is designed for building a response entity that includes a body. Since specifying the content type is directly related to the nature of the body being sent (like JSON, XML, plain text, etc.), it makes sense to include this method in the BodyBuilder.

In contrast, the HeadersBuilder is a more general builder used for constructing response entities where the focus might not necessarily be on the body content, but on other aspects of the HTTP response. Therefore, it does not include methods specific to the body, like setting the content type. This design choice helps in maintaining a separation of concerns, ensuring that each builder is tailored to its specific use case.

===================================================================================================================================================================
# HttpMessageConverter
In its default configuration, a Spring Boot controller is unable to convert a BufferedImage into an array of bytes in PNG or JPEG format. To facilitate this conversion, we need to register the appropriate HttpMessageConverter<T> bean within one of our configuration files. This helps Spring understand how to transform the BufferedImage into the desired format:


```java
@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Bean
    public HttpMessageConverter<BufferedImage> bufferedImageHttpMessageConverter() {
        return new BufferedImageHttpMessageConverter();
    }
    /*The BufferedImageHttpMessageConverter relies on the underlying Java Image I/O API,
        which does not natively support WebP format. As a result, when you request an image in the WebP format,
        the application doesn't have the capability to convert the BufferedImage to that format,
        leading to a failure in processing the request.
        To serve images in the WebP format, you would need additional libraries that support this format, 
        and you might have to implement a custom message converter that can handle WebP images. 
        Libraries like Apache Commons Imaging or others that support WebP could be integrated into your application for this purpose.
        */
}
```
