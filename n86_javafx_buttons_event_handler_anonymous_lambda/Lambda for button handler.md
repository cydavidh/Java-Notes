Basically we use lambda instead of the classic create new handler

```java
public class ButtonClickHandler implements EventHandler<ActionEvent> {
    @Override
    public void handle(ActionEvent event) {
        System.out.println("Button pressed!");
    }
}

// Usage
Button button = new Button("Click me");
button.setOnAction(new ButtonClickHandler());
```

```java
Button button = new Button("Click me");
button.setOnAction(event -> System.out.println("Button pressed!"));
```

======================================================================================================================
all we did in the tictactoe is

constructor
```java
public Cell() {
        this.symbol = "";
        this.button = new Button(" ");
        this.button.setFont(Font.font("Monospaced", 40));
        this.button.setOnAction(e -> this.handleButtonClick());
    }
```

a method
```java
public void handleButtonClick() {
    System.out.println("Button pressed!")
}
```