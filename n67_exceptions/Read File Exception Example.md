```java
public class FileReader {
    public void readFile(String filename) throws IOException {
        File file = new File(filename);
        if (!file.exists()) {
            throw new IOException("File does not exist");
        }
        // reads File
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Process the line...
            }
        }
    }
}

public class Main {
    public static void main(String[] args) {
        FileReader fileReader = new FileReader();
        try {
            fileReader.readFile("example.txt");
        } catch (IOException e) {
            System.out.println("An error occurred while reading the file: " + e.getMessage());
            // Handle the exception (e.g., log the error, notify the user, etc.)
            // Output: "An error occurred while reading the file: File does not exist"
        }
    }
}
```
