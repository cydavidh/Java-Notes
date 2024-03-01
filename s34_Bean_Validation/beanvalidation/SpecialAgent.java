package cydavidh.springdemo.beanvalidation;
import jakarta.validation.constraints.*;

public class SpecialAgent {
    @NotNull
    private String name;
    @NotEmpty(message = "not empty bro") //not null nor empty
    private String surname;
    @Size(min = 1, max = 3)
    @Pattern(regexp = "[0-9]{1,3}")
    private String code;
    @NotBlank //not null and must contain at least one non-whitespace character.
    private String status;
    @Min(value = 18, message = "Age must be greater than or equal to 18")
    private int age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
