build.gradle -refresh button in gradle panel on the right side
```groovy
plugins {
    // Apply the application plugin to add support for building a CLI application
    id("application")
    // Apply the plugin which adds support for Java
    id 'java'
    id 'org.springframework.boot' version '3.2.1'
    id 'io.spring.dependency-management' version '1.1.4'
}

group = 'org.hyperskill'
version = '0.0.1-SNAPSHOT'

java {
    sourceCompatibility = '17'
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter'
    implementation 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

tasks.named('test') {
    useJUnitPlatform()
}

// The auto-generated build.gradle(.kts) file has a section that configures the application plugin, thanks to which the application runs with the gradle run command.
application {
    // Defines the main class for the application
    mainClass = "org.hyperskill.gradleapp.App"
}
// The mainClass property defines a class with the entry point of the application. It allows us to run the application invoking the gradle run command.

task helloGradle {
    doLast {
        println 'Hello, Gradle!'
    }
}
```
If you would like to see all the possible Gradle tasks to perform, just run the gradle tasks --all command. 

==================================================================================================================================

application properties
```
server.port=9090
server.servlet.context-path=/myapp
```