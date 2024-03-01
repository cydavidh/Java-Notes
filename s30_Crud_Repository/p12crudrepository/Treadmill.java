package cydavidh.springdemo.p12crudrepository;


import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "treadmills")
public class Treadmill {
    @Id
    private String code;
    private String model;

    // Standard constructors, getters, and setters
    public Treadmill() {}

    public Treadmill(String code, String model) {
        this.code = code;
        this.model = model;
    }

    // Getters and setters
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }
}
