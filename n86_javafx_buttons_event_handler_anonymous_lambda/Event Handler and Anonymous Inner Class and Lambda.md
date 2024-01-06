**JavaFx Event Handler**

```java
Button button = new Button("This is a button");

button.setOnAction(new EventHandler<ActionEvent>() {
    @Override
    public void handle(ActionEvent event) {
        System.out.println("Pressed!");
    }
});

```
=================================================================================================
Sure, here's how you can **transform** the anonymous EventHandler class into a normal method in a class.

```java
public class ButtonClickHandler implements EventHandler<ActionEvent> {
    @Override
    public void handle(ActionEvent event) {
        System.out.println("Pressed!");
    }
}
```

```java
Button button = new Button("This is a button");
button.setOnAction(new ButtonClickHandler());
```
=================================================================================================
**setOnAction(EventHandler<ActionEvent> eventHandler)**
We give the `setOnAction` with an instance of a class that implements the `EventHandler` interface. This interface requires the handle method.
Since the `setOnAction` can only be provided with so, it knows that the parameter has a handler method.
So, when the button is clicked, the JavaFX system calls the `handle` method on the `EventHandler` instance you provided to `setOnAction`. 
If you provided an instance of an anonymous class, it will call the `handle` method in that anonymous class. 
If you provided an instance of `ButtonClickHandler`, it will call the `handle` method in `ButtonClickHandler`.


====================================================================================================
**Lambda expressions** in Java are essentially a simplified way to implement a method from a functional interface, which is an interface with a single abstract method. 

When you write a lambda expression like this:

```java
button.setOnAction(
    (event) -> {
        System.out.println("Pressed!");
    }
)
```

Java knows that this lambda expression is meant to implement the single abstract method in the functional interface. In the case of `EventHandler<ActionEvent>`, the single abstract method is `handle(ActionEvent event)`. 

So, when you pass this lambda to `setOnAction`, Java knows that it's implementing the `handle` method of the `EventHandler<ActionEvent>` interface. The `(event)` part of the lambda corresponds to the `ActionEvent event` parameter of the `handle` method, and the body of the lambda corresponds to the body of the `handle` method.

This is why you don't need to explicitly mention the `handle` method in the lambda expression. Java infers it based on the context in which the lambda is used.
====================================================================================================
**pass additional data to handle**
To pass additional data to the `handle` method, you can modify the `ButtonClickHandler` class to accept additional parameters in its constructor. These parameters can then be stored as instance variables and accessed within the `handle` method.

Here's an example:

```java
public class ButtonClickHandler implements EventHandler<ActionEvent> {
    private String additionalData;

    public ButtonClickHandler(String additionalData) {
        this.additionalData = additionalData;
    }

    @Override
    public void handle(ActionEvent event) {
        System.out.println("Pressed! Additional data: " + additionalData);
    }
}
```

In this version, the `ButtonClickHandler` constructor accepts a `String` parameter `additionalData`. This data is stored in an instance variable and is printed out along with the "Pressed!" message when the button is clicked.

You can use this class like this:

```java
Button button = new Button("This is a button");
button.setOnAction(new ButtonClickHandler("Some additional data"));
```

In this code, "Some additional data" is passed to the `ButtonClickHandler` constructor and will be printed out when the button is clicked.

==================================================================================================================

if-else in lambda

using `return` to jump over lines below jump out jump back

```java
button1.setOnAction((event) -> {
    if (textField1.getText().equals(dictionary.get(this.word))) {
        label2.setText("Correct");
    } else {
        label2.setText("Incorrect");
        return; //using return to jump over the following lines below
    }
    this.word = this.dictionary.getRandomWord();
    label1.setText("Translate the word '" + this.word + "'");
    textField1.clear();
});
```