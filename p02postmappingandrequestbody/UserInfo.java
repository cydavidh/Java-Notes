package cydavidh.springdemo.p02postmappingandrequestbody;

public class UserInfo {
    private int id;
    private String name;
    private String phone;
    private boolean enabled;

    // getters and setters
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getPhone() {
        return phone;
    }

    public boolean isEnabled() {
        return enabled;
    }

    UserInfo() {}
}
