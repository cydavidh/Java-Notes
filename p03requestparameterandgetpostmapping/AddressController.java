package cydavidh.springdemo.p03requestparameterandgetpostmapping;

import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ConcurrentHashMap;

@RestController
public class AddressController {
    private ConcurrentHashMap<String, String> addressBook = new ConcurrentHashMap<>();
    @GetMapping("/address")
    public ConcurrentHashMap<String, String> getAddressBook() {
        return addressBook;
    }

    @PostMapping("/address")
    public String postAddress(@RequestParam String name, @RequestParam String address) {
        String previousAddress = addressBook.put(name, address);
        if (previousAddress == null) {
            return "New address added for " + name;
        } else {
            return "Address updated for " + name;
        }
    }

    @GetMapping("/address/{name}")
    public String getAddress(@PathVariable String name) {
        return addressBook.get(name);
    }

    @DeleteMapping("/address")
    public String deleteAddress(@RequestParam String name) {
        String previousAddress = addressBook.remove(name);
        if (previousAddress == null) {
            return "no address associated with " + name;
        } else {
            return "address deleted for " + name;
        }
    }
}
