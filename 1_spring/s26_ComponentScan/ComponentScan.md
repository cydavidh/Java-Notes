In spring you have to do @ComponentScan to get the Beans instantiated

@Component
public class MyService {
    // class definition
}

@Configuration
@ComponentScan(basePackages = "com.example.myapp")
public class AppConfig {
    // No need to explicitly define a bean for MyService here
}

you don't need to in spring.
==============================================================

package com.mycompany.config;

import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan(???)
public class Config {
    // some code
}

Also, there are @Repository classes inside the com.mycompany.repository package and @Service classes inside the com.mycompany.service package.

What attribute can be used in the @ComponentScan annotation over the Config class to make the Config class aware of all these services and repositories? You have the following options:

Java
A) @ComponentScan(basePackages = "com.mycompany")

C) @ComponentScan(basePackages = {"com.mycompany.repository", "com.mycompany.service"})

D) @ComponentScan("com.mycompany")