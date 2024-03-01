package cydavidh.springdemo.p08qrcode;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.awt.image.BufferedImage;

@RestController
public class ApiController {
    private final ImageCreator imageCreator;

    @Autowired
    public ApiController(ImageCreator imageCreator) {
        this.imageCreator = imageCreator;
    }

    @GetMapping("/api/health")
    public ResponseEntity<String> health() {
        return new ResponseEntity<>("OK", HttpStatus.OK);
    }

    @GetMapping(path = "/api/qrcode")
    public ResponseEntity<BufferedImage> getImage() {
        BufferedImage bufferedImage = imageCreator.createBufferedImage();
        return ResponseEntity
                .ok()
                .contentType(MediaType.IMAGE_PNG)
                .body(bufferedImage);
    }
}
