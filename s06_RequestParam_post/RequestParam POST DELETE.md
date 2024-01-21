```java
@RestController
public class AddressController {
    private ConcurrentMap<String, String> addressBook = new ConcurrentHashMap<>();
	
    @PostMapping("/addresses")
    public void postAddress(@RequestParam String name, @RequestParam String address) {
        addressBook.put(name, address);
    }		
}
```

```
localhost:8080/addresses?name=Bob&address=123 Young Street
```


=====================================================================
# Test Succeed or not

# either
# 1 implement a GET request that returns a requested address based on the provided name.
# 2 use the return of the HashMap.put to determine if the operation added a new entry or updated an existing one
```java
@RestController
public class AddressController {
    private ConcurrentMap<String, String> addressBook = new ConcurrentHashMap<>();
	
    public String postAddress(@RequestParam String name, @RequestParam String address) {
        String previousAddress = addressBook.put(name, address);
        if (previousAddress == null) {
            return "New address added for " + name;
        } else {
            return "Address updated for " + name;
        }
    } 
	
    @GetMapping("/addresses/{name}")
    public String getAddress(@PathVariable String name) {
        return addressBook.get(name);
    }
}
```

=====================================================================

400 Bad Request error will occur if POST parameters are missing or incorrect.

=====================================================================

```java
@DeleteMapping("/address")
    public String deleteAddress(@RequestParam String name) {
        String previousAddress = addressBook.remove(name);
        if (previousAddress == null) {
            return "no address associated with " + name;
        } else {
            return "address deleted for " + name;
        }
    }
```