hashmap.keySet() returns a "set" of all keys
set does not have get()
to iterate over it we use for-each loop (enhanced for loop) e.g. for (String something : List list)
or we use iterator
https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/util/Set.html

```java
public static void main(String[] args) {
    HashMap<String, String> postalCodes = new HashMap<>();
    postalCodes.put("00710", "Helsinki");
    postalCodes.put("12345", "Taipei");
    postalCodes.put("56565", "New York");

    Iterator<String> iterator = postalCodes.keySet().iterator();
    while (iterator.hasNext()) {
        System.out.println(iterator.next());
    }

}
```