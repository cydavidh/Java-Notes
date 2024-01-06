Hbox
```java
public void start(Stage stage) {
    Hbox hbox = new Hbox();
    hbox.setSpacing(8);
    layout.getChildren().add(new Label("first"));
    layout.getChildren().add(new Label("second"));
    layout.getChildren().add(new Label("third"));
    Scene scene = new Scene(hbox);
    stage.setScene(scene);
    stage.show()
}
```
```
first    second    third
```
===========================================================================================================================

GridPane
```java
public void start(Stage stage) {
    GridPane gridPane = new GridPane();
    gridPane.setPadding(new Insets(10)); // same as gridPane.setPadding(new Insets(10, 10, 10, 10))
    gridPane.setHgap(10);
    gridPane.setVgap(10);
    for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 3; y++) {
            gridPane.add(new Button(String.format("%d, %d", x, y)), x, y); //x horizontal y vertical
        }
    }

    Scene scene = new Scene(gridPane);
    stage.setScene(scene);
    stage.show();
}
```
```
0,0 1,0 2,0
0,1 1,1 2,1 
0,2 1,2 2,2
```
===========================================================================================================================


BorderPane to combine all
```java
public void start(Stage window) {
    BorderPane layout = new BorderPane();

    HBox buttons = new HBox();
    buttons.setSpacing(10);
    buttons.getChildren().add(new Button("Button1"));
    buttons.getChildren().add(new Button("Button2"));
    buttons.getChildren().add(new Button("Button3"));

    VBox texts = new VBox();
    texts.setSpacing(10);
    texts.getChildren().add(new Label("First"));
    texts.getChildren().add(new Label("Second"));
    texts.getChildren().add(new Label("Third"));

    layout.setTop(buttons);
    layout.setLeft(texts);
    layout.setCenter(new TextArea(""));

    Scene view = new Scene(layout);

    window.setScene(view);
    window.show();
}
```
```
Button1 Button2 Button3
First   |-----------------------|
Second  | TextArea              |
Third   |-----------------------|
```