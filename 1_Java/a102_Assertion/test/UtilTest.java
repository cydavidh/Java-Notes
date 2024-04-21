import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertArrayEquals;

public class UtilTest {
    @Test
    public void testSwapInts() {
        int[] ints = {1, 2};
        Util.swapInts(ints);
        System.out.println(ints[0]);
        assertArrayEquals(new int[] {2, 1}, ints);
    }
}
