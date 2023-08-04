.getOrDefault(Object key, V defaultValue)

public class registerSightingCounter {
    private HashMap<String, Integer> allSightings;

    public registerSightingCounter() {
        //constructor
    }

    public void addSighting(String sighted) {
        //add sighting
    }

    public int timesSighted(String sighted) {
        return this.allSightings.get(sighted);
    }
}

If we get null returned when we call timesSighted method. we get a java.lang.reflect.InvocationTargetException error.
cuz we can't convert null to int.

so we use getOrDefault(sighted, 0)

public int timesSighted(String sighted) {
    return this.allSightings.getOrDefault(sighted, 0);
}

this will return 0 if sighted isn't in the hashmap.