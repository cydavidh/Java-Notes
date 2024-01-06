we usually use BorderPane, and then use other layouts inside borderpane, maybe even swap them around.

```java
borderPane.setCenter(anotherPaneLikeStackPane);
```

some methods of panes to style
```java
layout.setPrefSize(300, 180);
layout.setAlignment(Pos.CENTER);
layout.setVgap(10);
layout.setHgap(10);
layout.setPadding(new Insets(20, 20, 20, 20));
```