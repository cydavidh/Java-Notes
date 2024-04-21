A private constructor means only code within the class itself can instantiate an object of that type, so if the private constructor class wants to allow an instance of the class to be used, the class must provide a static method or variable that allows access to an instance created from within the class.

example
```java
public class DatabaseConnection {
    private static DatabaseConnection instance;

    // Private constructor prevents instantiation from other classes
    private DatabaseConnection() {
        // Initialization code here, such as establishing a database connection
    }

    // Global point of access
    public static DatabaseConnection getInstance() {
        if (instance == null) {
            // Ensure that the instance is created only once
            instance = new DatabaseConnection();
        }
        return instance;
    }

    // Other methods and fields related to database connection
    public void connect() {
        // Connection code
    }
}

```
connect to oracle
```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class OracleDatabaseConnection {
    // JDBC URL, username and password of Oracle DB
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:yourDB";
    private static final String USER = "yourUsername";
    private static final String PASS = "yourPassword";

    // Single instance of the class
    private static OracleDatabaseConnection instance;
    private Connection connection;

    // Private constructor
    private OracleDatabaseConnection() {
        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // Establish connection to the database
            this.connection = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            System.out.println("Oracle JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection to Oracle database failed.");
            e.printStackTrace();
        }
    }

    // Public method to get instance
    public static OracleDatabaseConnection getInstance() {
        if (instance == null) {
            instance = new OracleDatabaseConnection();
        }
        return instance;
    }

    // Method to get database connection
    public Connection getConnection() {
        return connection;
    }

    // Other database operation methods
}

```