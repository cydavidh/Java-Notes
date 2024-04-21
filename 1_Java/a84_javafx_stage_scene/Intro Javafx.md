Stage
Scene
Pane

```java
public void start(Stage stage) {
    StackPane pane = new StackPane();
    Scene scene = new Scene(pane);
    stage.setScene(scene);
    stage.show();
}
public static void main(String[] args) {
    launch(App.class);
}
```

```java
public void start(Stage stage) {
    Button button = new Button("This is Button");

    StackPane pane = new StackPane();
    pane.getChildren().add(button);

    Scene scene = new Scene(pane);
    stage.setScene(scene);
    stage.show();
}
```

Panes:
BorderPane
HBox
VBox
StackPane
GridPane
FlowPane
TilePane
AnchorPane
Additional Resources
Application Files

UI elements:
2 Label
3 Button
4 Radio Button
5 Toggle Button
6 Checkbox
7 Choice Box
8 Text Field
9 Password Field
10 Scroll Bar
11 Scroll Pane
12 List View
13 Table View
14 Tree View
15 Tree Table View
16 Combo Box
17 Separator
18 Slider
19 Progress Bar and Progress Indicator
20 Hyperlink
21 HTML Editor
22 Tooltip
23 Titled Pane and Accordion
24 Menu
25 Color Picker
26 Date Picker
27 Pagination Control
28 File Chooser
29 Customization of UI Controls
30 UI Controls on the Embedded Platforms


