https://docs.oracle.com/javase/tutorial/java/concepts/interface.html
What is interface.

```java
public interface Readable {
    String read();
}
```

```java
public class TextMessage implements Readable {
    private String sender;
    private String content;

    public TextMessage(String sender, String content) {
        this.sender = sender;
        this.content = content;
    }

    public String getSender() {
        return this.sender;
    }

    public String read() {
        return this.content;
    }
}
```