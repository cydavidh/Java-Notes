package cydavidh.springdemo.p05responseentityandbufferedimage;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Map;

/* put in Application class
    @Bean
    public HttpMessageConverter<BufferedImage> bufferedImageHttpMessageConverter() {
        return new BufferedImageHttpMessageConverter();
    }
 */
@RestController
public class ImageController {
    private final Map<String, BufferedImage> images = Map.of(
            "green", createImage(Color.GREEN),
            "magenta", createImage(Color.MAGENTA)
    );


    private static BufferedImage createImage(Color color) {
        BufferedImage image = new BufferedImage(20, 20, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = image.createGraphics();
        g.setColor(color);
        g.fillRect(0, 0, 20, 20);
        g.dispose();

        return image;
    }

    @GetMapping("/image")
    public ResponseEntity<BufferedImage> getImage(@RequestParam String name,
                                                  @RequestParam String mediaType) {
        BufferedImage image = images.get(name);
        if (image == null) {
            return ResponseEntity.notFound().build();
        } else {
            return ResponseEntity.ok().contentType(MediaType.parseMediaType(mediaType)).body(image);
        }
    }


}
