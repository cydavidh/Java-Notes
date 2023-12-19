```java
public class SaveableDictionary {
    private Map<String, String> words;
    private File file;
    public SaveableDictionary(String file) {
        this.words = new HashMap<>();
        this.file = new File(file);
    }

    public boolean load() {
        try {
            //Files.lines(Paths.get(this.file.getPath()))
            Files.lines(this.file.toPath()).map(row -> row.split(":")).filter(array -> array.length == 2)
                    .forEach(array -> this.add(array[0], array[1]));
            return true;
        } catch (IOException ioException) {
            ioException.printStackTrace();
            return false;
        }
    }
}
```