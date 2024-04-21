Yes, that's correct. The `allMatch(sensor -> sensor.isOn())` expression is simply checking if the `isOn()` method returns `true` for each individual sensor in the stream. It's not comparing the `isOn()` state of each sensor against any external `isOn()` method or state.

Here's a step-by-step explanation:

1. `list.stream()` creates a stream of sensors.
2. `allMatch(sensor -> sensor.isOn())` checks if the `isOn()` method returns `true` for each sensor in the stream.

So, `list.stream().allMatch(sensor -> sensor.isOn())` returns `true` if all sensors are on, and `false` otherwise.

This is equivalent to the loop in your original `isOn()` method, but it's more concise and makes use of Java's Stream API.

```java
public class AverageSensor implements Sensor {
    List<Sensor> list;

    public boolean isOn() {

        return list.stream().allMatch(sensor -> sensor.isOn())

        // boolean check = true;
        // for (Sensor sensor : list) {
        //     if (!sensor.isOn()) {
        //         return false;
        //     }
        // }
        // return true;
    };
}
```