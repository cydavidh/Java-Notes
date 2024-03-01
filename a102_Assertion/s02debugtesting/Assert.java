package cydavidh.sandbox.s02debugtesting;

import java.util.logging.Logger;

public class Assert {
    private static Logger logger = Logger.getLogger(Assert.class.getName());

    public static void main(String[] args) {
        try {
            String str = null;
            assert (str!=null) : "Hey bro string cannot be null";
            System.out.println(str.length());
        } catch (NullPointerException e) {
            logger.warning("A NullPointerException was caught: " + e.getMessage());
        }
    }
}

// how to enable flag: 1. run it. 2. three dots next to the terminal 3. edit run convig 4. vm options 5. add -ea
// how to run build with idea instead of gradle settings gradle build and run using IDEA