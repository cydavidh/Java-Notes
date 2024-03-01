```java
try (put resources here) {
    read line
} catch (Exception e) {

}
```
automatically closes the resources after using it.


# Example 1
```java
ArrayList<String> lines =  new ArrayList<>();

try (Scanner reader = new Scanner(new File("file.txt"))) {
    while (reader.hasNextLine()) {
        lines.add(reader.nextLine());
    }
} catch (Exception e) {
    System.out.println("Error: " + e.getMessage());
}
```
# Example 2
```java
Map<String, String> translations = new HashMap<>();
File file = new File("word.txt");

try (PrintWriter out = new PrintWriter(file)) {
    for (String key : words.keySet()) {
        out.println(String.format("%s:%s", key, words.get(key))); // sawadeekrub:hello
    }
} catch (IOException ioException) {
    ioException.printStackTrace();
}
```