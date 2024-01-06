```java
public class Main {
    public static void main(String[] args) {
        Application.launch(JavaFxApplication.class,
            "--organization=Once upon a time",
            "--course=Title");
    }
}
```


```java
public class JavaFxApplication extends Application {
    @Override
    public void start(Stage window) {
        Parameters params = getParameters();
        String organization = params.getNamed().get("organization");
        String course = params.getNamed().get("course");

        window.setTitle(organization + ": " + course); //Once upon a time: Title
        window.show();
    }
}
```