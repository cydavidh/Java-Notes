package cydavidh.springdemo.p08qrcode;

import org.springframework.stereotype.Service;

import java.awt.*;
import java.awt.image.BufferedImage;
@Service

public class ImageCreator {
    public BufferedImage createBufferedImage() {
        BufferedImage bufferedImage = new BufferedImage(250, 250, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bufferedImage.createGraphics();
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, 250, 250);
        g.dispose();
        return bufferedImage;
    }
}
