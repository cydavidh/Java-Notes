Java in a Nutshell: 346 How to read from and write to file

```java
PrintWriter writer = new PrintWriter("file.txt");
writer.println("Hello file!"); //writes the string "Hello file!" and line change to the file
writer.println("More text");
writer.print("And a little extra"); // writes the string "And a little extra" to the file without a line change
writer.close(); //closes the file and ensures that the written text is saved to the file
```

# Append
```java
System.out.println(System.getProperty("user.dir")); // C:\Java-DSA-Notes
try {
    PrintWriter writer = new PrintWriter(new FileWriter("n70_write_to_file/file.txt", true));
    writer.println("Appended text");
    writer.close();
} catch (IOException e) {
    e.printStackTrace();
}
```


Java in a Nutshell: 346 How to write to file
```java
var f = new File(System.getProperty("user.dir") + File.separator + ".bashrc");
try (var out = new PrintWriter(new BufferedWriter(new FileWriter(f)))) {
    out.println("## Automatically generated config file. DO NOT EDIT");
    // ...
} catch (IOException iox) {
    iox.printStackTrace();
}
```