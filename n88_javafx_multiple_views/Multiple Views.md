```java
Button goToSecond = new Button("goToSecond");
Button goToFirst = new Button("goToFirst");

Scene firstScene = new Scene(goToSecond);
Scene secondScene = new Scene(goToFirst);

goToSecond.setOnAction((event) -> {
    window.setScene(secondScene);
});

goToFirst.setOnAction((event) -> {
    window.setScene(firstScene);
});

window.setScene(firstScene);
window.show();
```

```java
public void start(Stage window) {
    Button button1 = new Button("Button 1");
    Pane layout1 = new Pane();
    layout1.getChildren().add(button1);
    Scene scene1 = new Scene(layout1);

    Label label2 = new Label("Label 2");
    Pane layout2 = new Pane();
    layout2.getChildren().add(button2);
    Scene scene2 = new Scene(layout2);

    button1.setOnAction((event) -> {
        window.setScene(layout2);
    })

    window.setScene(layout1);
    window.show();
}
```

```java
public void start(Stage window) {
    Button button1 = new Button("Button 1");
    Button button2 = new Button("Button 2");
    Pane layout = new Pane();
    layout.getChildren().add(button1);
    layout.getChildren().add(button2);

    Pane firstSubLayout = new Pane();
    Pane secondSubLayout = new Pane();

    button1.setOnAction((event) -> layout.setCenter(firstLayout));
    button2.setOnAction((event) -> layout.setCenter(secondLayout));

    layout.setCenter(firstSubLayout);

    Scene scene = new Scene(layout);
    window.setScene(scene);
    window.show();
}
```