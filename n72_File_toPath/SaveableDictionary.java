import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;

public class SaveableDictionary {
    private Map<String, String> words;
    private File file;

    public boolean load() {
        try {
            // Files.lines(Paths.get(this.file.getPath()))
            Files.lines(this.file.toPath()).map(row -> row.split(":")).filter(array -> array.length == 2)
                    .forEach(array -> this.add(array[0], array[1]));
            return true;
        } catch (IOException ioException) {
            ioException.printStackTrace();
            return false;
        }
    }



    public SaveableDictionary(String file) {
        this.words = new HashMap<>();
        this.file = new File(file);
    }



    public void add(String word, String translation) {
        words.putIfAbsent(word, translation);
        words.putIfAbsent(translation, word);
    }
}
